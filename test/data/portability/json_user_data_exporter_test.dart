import 'dart:convert';
import 'dart:io';

import 'package:diarioup/diarioup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'esporta tutti i compiti in JSON e rimuove il file temporaneo',
    () async {
      final temporary = await Directory.systemTemp.createTemp(
        'diarioup-json-export-',
      );
      addTearDown(() async {
        if (await temporary.exists()) await temporary.delete(recursive: true);
      });
      String? sharedPath;
      Map<String, Object?>? payload;
      final exporter = JsonUserDataExporter(
        repository: _HomeworkRepository(<HomeworkAgendaItem>[
          _homework('pending', isDone: false),
          _homework('completed', isDone: true),
        ]),
        appVersion: '1.2.3+4',
        temporaryDirectoryLoader: () async => temporary,
        uniqueId: () => 'backup-test',
        now: () => DateTime.utc(2026, 9, 28, 18),
        nativeShare: ({required path, required fileName, origin}) async {
          sharedPath = path;
          expect(fileName, 'DiarioUp-backup-20260928-1800.json');
          payload =
              jsonDecode(await File(path).readAsString())
                  as Map<String, Object?>;
        },
      );

      final count = await exporter.exportJson(profileId: 'profile-1');

      expect(count, 2);
      expect(payload?['format'], 'diarioup-homework-backup');
      expect(payload?['schemaVersion'], 1);
      final homework = payload?['homework']! as List<Object?>;
      expect(homework, hasLength(2));
      expect(homework.cast<Map<String, Object?>>().last['completed'], isTrue);
      expect(await File(sharedPath!).exists(), isFalse);
    },
  );
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

HomeworkAgendaItem _homework(String id, {required bool isDone}) {
  return HomeworkAgendaItem(
    id: id,
    profileId: 'profile-1',
    text: 'Compito $id',
    subjectId: 'subject-1',
    subjectName: 'Italiano',
    assignedOn: const SchoolDate(2026, 9, 28),
    dueOn: const SchoolDate(2026, 10, 1),
    isDone: isDone,
    doneAt: isDone ? DateTime.utc(2026, 9, 29) : null,
    changedAfterCompletion: false,
    requiresIdentityReview: false,
    origin: HomeworkOrigin.manual,
    updatedAt: DateTime.utc(2026, 9, 28),
    personalNote: 'Nota personale',
  );
}
