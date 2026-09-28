import 'dart:typed_data';

import 'package:diarioup/diarioup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final monday = const SchoolDate(2026, 9, 28);

  test('esclude sempre i compiti completati prima dell esportazione', () {
    final homework = <HomeworkAgendaItem>[
      _homework(
        'pending',
        dueOn: const SchoolDate(2026, 9, 30),
        subjectId: 'math',
      ),
      _homework(
        'done',
        dueOn: const SchoolDate(2026, 9, 30),
        subjectId: 'math',
        isDone: true,
      ),
    ];

    final forWeek = HomeworkExportFilter.apply(
      homework: homework,
      selection: HomeworkExportSelection.week(monday),
    );
    final forDay = HomeworkExportFilter.apply(
      homework: homework,
      selection: HomeworkExportSelection.day(const SchoolDate(2026, 9, 30)),
    );
    final forSubject = HomeworkExportFilter.apply(
      homework: homework,
      selection: HomeworkExportSelection.subject(
        subjectId: 'math',
        subjectName: 'Matematica',
      ),
    );

    expect(forWeek.map((item) => item.id), <String>['pending']);
    expect(forDay.map((item) => item.id), <String>['pending']);
    expect(forSubject.map((item) => item.id), <String>['pending']);
  });

  test('il caso d uso rimuove i completati prima di generare il PDF', () async {
    final generator = _CapturingPdfGenerator();
    final sharer = _CapturingFileSharer();
    final useCase = ShareHomework(
      repository: _HomeworkRepository(<HomeworkAgendaItem>[
        _homework('pending', dueOn: const SchoolDate(2026, 9, 30)),
        _homework('done', dueOn: const SchoolDate(2026, 9, 30), isDone: true),
      ]),
      pdfGenerator: generator,
      fileSharer: sharer,
      now: () => DateTime(2026, 9, 28, 18),
    );

    final result = await useCase(
      profileId: 'profile-1',
      selection: HomeworkExportSelection.week(monday),
    );

    expect(generator.received.map((item) => item.id), <String>['pending']);
    expect(sharer.callCount, 1);
    expect(result.status, HomeworkShareStatus.shared);
    expect(result.itemCount, 1);
  });

  test('la settimana va da lunedi a domenica ed esclude le date assenti', () {
    final result = HomeworkExportFilter.apply(
      homework: <HomeworkAgendaItem>[
        _homework('monday', dueOn: const SchoolDate(2026, 9, 28)),
        _homework('sunday', dueOn: const SchoolDate(2026, 10, 4)),
        _homework('next', dueOn: const SchoolDate(2026, 10, 5)),
        _homework('missing'),
      ],
      selection: HomeworkExportSelection.week(const SchoolDate(2026, 10, 1)),
    );

    expect(result.map((item) => item.id), <String>['monday', 'sunday']);
  });

  test('il filtro materia conserva i senza scadenza e li ordina in fondo', () {
    final result = HomeworkExportFilter.apply(
      homework: <HomeworkAgendaItem>[
        _homework('without-date', subjectId: 'italian'),
        _homework(
          'dated',
          subjectId: 'italian',
          dueOn: const SchoolDate(2026, 10, 2),
        ),
        _homework('other', subjectId: 'math'),
      ],
      selection: HomeworkExportSelection.subject(
        subjectId: 'italian',
        subjectName: 'Italiano',
      ),
    );

    expect(result.map((item) => item.id), <String>['dated', 'without-date']);
  });
}

final class _HomeworkRepository implements DidupRepository {
  _HomeworkRepository(this.homework);

  final List<HomeworkAgendaItem> homework;

  @override
  Stream<List<HomeworkAgendaItem>> watchHomework({required String profileId}) =>
      Stream<List<HomeworkAgendaItem>>.value(homework);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _CapturingPdfGenerator implements HomeworkPdfGenerator {
  List<HomeworkAgendaItem> received = const <HomeworkAgendaItem>[];

  @override
  Future<Uint8List> generate({
    required List<HomeworkAgendaItem> homework,
    required HomeworkExportSelection selection,
    required DateTime generatedAt,
  }) async {
    received = homework;
    return Uint8List.fromList(<int>[37, 80, 68, 70, 45]);
  }
}

final class _CapturingFileSharer implements HomeworkFileSharer {
  var callCount = 0;

  @override
  Future<void> sharePdf({
    required Uint8List bytes,
    required String fileName,
    ShareSheetOrigin? origin,
  }) async {
    callCount++;
  }
}

HomeworkAgendaItem _homework(
  String id, {
  SchoolDate? dueOn,
  String? subjectId,
  bool isDone = false,
}) {
  return HomeworkAgendaItem(
    id: id,
    profileId: 'profile-1',
    text: 'Compito $id',
    subjectId: subjectId,
    subjectName: subjectId,
    dueOn: dueOn,
    isDone: isDone,
    changedAfterCompletion: false,
    requiresIdentityReview: false,
    origin: HomeworkOrigin.manual,
    updatedAt: DateTime.utc(2026, 9, 28),
  );
}
