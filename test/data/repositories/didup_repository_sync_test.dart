import 'dart:io';
import 'dart:typed_data';

import 'package:diarioup/diarioup.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

void main() {
  test(
    'condivide tutte le settimane dal database anche con il solo compito odierno da fare',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await database.storeProfiles(const [
        StudentProfile(
          sourceProfileId: 'profile-1',
          displayLabel: 'Profilo test',
          schoolMinistryCode: 'TEST0001',
          academicYear: '2026/2027',
        ),
      ]);
      final sessionStore = MemorySessionStore(
        testSession(expiresAt: DateTime.utc(2027)).copyWith(
          profiles: {
            'profile-1': testSession(
              expiresAt: DateTime.utc(2027),
            ).profiles['profile-1']!.withSchoolClassLabel('I B'),
          },
        ),
      );
      final network = DidupNetworkClient.create(config: testProtocolConfig());
      addTearDown(network.dio.close);
      final repository = DidupRepositoryImpl(
        authService: _UnusedAuthService(),
        client: DidupClient(networkClient: network, sessionStore: sessionStore),
        database: database,
        sessionStore: sessionStore,
        normalizer: HomeworkNormalizer(
          identityRegistry: DriftHomeworkIdentityRegistry(database: database),
        ),
        adapterVersion: 'test-v1',
        dashboardSource: _MutableDashboardSource({
          'data': {
            'dati': [
              {
                'registro': [
                  for (final (id, subject, date) in [
                    ('passato', 'Italiano', '01/09/2026'),
                    ('oggi', 'Italiano', '10/11/2026'),
                    ('futuro', 'Italiano', '31/12/2030'),
                    ('passato-math', 'Matematica', '02/09/2026'),
                    ('senza-data', 'Matematica', null),
                  ])
                    {
                      'pk': 'record-$id',
                      'materia': subject,
                      'datGiorno': '01/09/2026',
                      'compiti': [
                        {'compito': 'ESERCIZIO_$id', 'dataConsegna': date},
                      ],
                    },
                ],
              },
            ],
          },
        }),
        now: () => DateTime.utc(2026, 11, 10),
      );
      await repository.sync(profileId: 'profile-1');
      final homework = await repository
          .watchHomework(profileId: 'profile-1')
          .first;
      expect(homework, hasLength(5));
      for (final item in homework) {
        if (item.text == 'ESERCIZIO_oggi') continue;
        await repository.setHomeworkCompleted(
          profileId: 'profile-1',
          homeworkId: item.id,
          isDone: true,
        );
      }
      final subjects = await repository
          .watchSubjects(profileId: 'profile-1')
          .first;
      final generator = _RecordingPdfGenerator(
        DiarioUpPdfGenerator(
          logoBytes: await File('assets/logo_diarioup.png').readAsBytes(),
          fontBytes: await File(
            'assets/fonts/inter/InterVariable.ttf',
          ).readAsBytes(),
        ),
      );
      final sharer = _RecordingFileSharer();
      final share = ShareHomework(
        repository: repository,
        pdfGenerator: generator,
        fileSharer: sharer,
        now: () => DateTime(2026, 11, 10, 18, 30),
      );
      final result = await share(
        profileId: 'profile-1',
        selection: HomeworkExportSelection.subjects({
          for (final subject in subjects) subject.id: subject.name,
        }),
      );
      expect(result.itemCount, 5);
      expect(generator.received.map((item) => item.text), [
        'ESERCIZIO_passato',
        'ESERCIZIO_oggi',
        'ESERCIZIO_futuro',
        'ESERCIZIO_passato-math',
        'ESERCIZIO_senza-data',
      ]);
      expect(generator.received.where((item) => item.isDone), hasLength(4));
      expect(generator.receivedClassLabel, 'I B');
      expect(sharer.fileName, 'materie_2_intero_storico_10_11_2026.pdf');
      expect(String.fromCharCodes(sharer.bytes.take(5)), '%PDF-');
      if (const bool.fromEnvironment('DIARIOUP_PDF_REVIEW')) {
        await Directory('tmp/pdfs').create(recursive: true);
        await File(
          'tmp/pdfs/regressione_storico.pdf',
        ).writeAsBytes(sharer.bytes);
      }

      final single = subjects.firstWhere(
        (subject) => subject.name == 'Italiano',
      );
      final singleResult = await share(
        profileId: 'profile-1',
        selection: HomeworkExportSelection.subject(
          subjectId: single.id,
          subjectName: single.name,
        ),
      );
      expect(singleResult.itemCount, 3);
      expect(generator.received.map((item) => item.text), [
        'ESERCIZIO_passato',
        'ESERCIZIO_oggi',
        'ESERCIZIO_futuro',
      ]);
    },
  );

  test(
    'sync atomica preserva il completamento dopo una modifica remota',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await database.storeProfiles(const <StudentProfile>[
        StudentProfile(
          sourceProfileId: 'profile-1',
          displayLabel: 'Profilo test',
          schoolMinistryCode: 'TEST0001',
          academicYear: '2026/2027',
        ),
      ]);
      final sessionStore = MemorySessionStore(
        testSession(expiresAt: DateTime.utc(2026, 10)),
      );
      final network = DidupNetworkClient.create(config: testProtocolConfig());
      addTearDown(network.dio.close);
      final source = _MutableDashboardSource(_dashboard('Testo iniziale'));
      final repository = DidupRepositoryImpl(
        authService: _UnusedAuthService(),
        client: DidupClient(networkClient: network, sessionStore: sessionStore),
        database: database,
        sessionStore: sessionStore,
        normalizer: HomeworkNormalizer(
          identityRegistry: DriftHomeworkIdentityRegistry(database: database),
          now: () => DateTime.utc(2026, 9, 28, 12),
        ),
        adapterVersion: 'test-v1',
        dashboardSource: source,
        now: () => DateTime.utc(2026, 9, 28, 12),
      );

      await repository.sync(profileId: 'profile-1');
      var items = await repository
          .watchHomework(profileId: 'profile-1')
          .firstWhere((value) => value.isNotEmpty);
      final stableId = items.single.id;
      await repository.setHomeworkCompleted(
        profileId: 'profile-1',
        homeworkId: stableId,
        isDone: true,
      );
      await repository.updateHomeworkNote(
        profileId: 'profile-1',
        homeworkId: stableId,
        note: 'Portare il quaderno',
      );

      source.response = _dashboard('Testo modificato');
      await repository.sync(profileId: 'profile-1');
      items = await repository
          .watchHomework(profileId: 'profile-1')
          .firstWhere((value) => value.isNotEmpty);

      expect(items.single.id, stableId);
      expect(items.single.text, 'Testo modificato');
      expect(items.single.isDone, isTrue);
      expect(items.single.changedAfterCompletion, isTrue);
      expect(items.single.personalNote, 'Portare il quaderno');
    },
  );
}

final class _RecordingPdfGenerator implements HomeworkPdfGenerator {
  _RecordingPdfGenerator(this.delegate);

  final HomeworkPdfGenerator delegate;
  List<HomeworkAgendaItem> received = const [];
  String? receivedClassLabel;

  @override
  Future<Uint8List> generate({
    required List<HomeworkAgendaItem> homework,
    required HomeworkExportSelection selection,
    required DateTime generatedAt,
    String? schoolClassLabel,
  }) {
    received = homework;
    receivedClassLabel = schoolClassLabel;
    return delegate.generate(
      homework: homework,
      selection: selection,
      generatedAt: generatedAt,
      schoolClassLabel: schoolClassLabel,
    );
  }
}

final class _RecordingFileSharer implements HomeworkFileSharer {
  Uint8List bytes = Uint8List(0);
  String? fileName;

  @override
  Future<void> sharePdf({
    required Uint8List bytes,
    required String fileName,
    ShareSheetOrigin? origin,
  }) async {
    this.bytes = bytes;
    this.fileName = fileName;
  }
}

final class _MutableDashboardSource implements DidupDashboardSource {
  _MutableDashboardSource(this.response);

  Map<String, Object?> response;

  @override
  Future<Map<String, Object?>> download({
    required String profileId,
    required DateTime since,
  }) async => response;
}

final class _UnusedAuthService implements DidupAuthService {
  @override
  Future<RemoteLoginResult> login(AuthCredentials credentials) =>
      throw UnsupportedError('Login non usato da questo test.');
}

Map<String, Object?> _dashboard(String text) => <String, Object?>{
  'success': true,
  'data': <String, Object?>{
    'dati': <Object?>[
      <String, Object?>{
        'registro': <Object?>[
          <String, Object?>{
            'pk': 'record-without-child-id',
            'datGiorno': '28/09/2026',
            'materia': 'Italiano',
            'compiti': <Object?>[
              <String, Object?>{'compito': text, 'dataConsegna': '29/09/2026'},
            ],
          },
        ],
      },
    ],
  },
};
