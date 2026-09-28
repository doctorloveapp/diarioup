import 'package:diarioup/diarioup.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

void main() {
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

      source.response = _dashboard('Testo modificato');
      await repository.sync(profileId: 'profile-1');
      items = await repository
          .watchHomework(profileId: 'profile-1')
          .firstWhere((value) => value.isNotEmpty);

      expect(items.single.id, stableId);
      expect(items.single.text, 'Testo modificato');
      expect(items.single.isDone, isTrue);
      expect(items.single.changedAfterCompletion, isTrue);
    },
  );
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
