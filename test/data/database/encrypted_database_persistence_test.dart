import 'dart:async';
import 'dart:io';

import 'package:diarioup/src/data/database/app_database.dart';
import 'package:diarioup/src/data/database/encrypted_database_factory.dart';
import 'package:diarioup/src/domain/auth/student_profile.dart' as domain;
import 'package:diarioup/src/domain/homework/homework.dart' as domain;
import 'package:diarioup/src/domain/homework/school_date.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('compiti e checklist persistono dopo la riapertura cifrata', () async {
    final directory = await Directory.systemTemp.createTemp(
      'diarioup-encrypted-db-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File(
      '${directory.path}${Platform.pathSeparator}agenda.sqlite',
    );
    const key = 'test-only-32-byte-database-key-value';

    AppDatabase open() => AppDatabase(
      NativeDatabase(
        file,
        setup: (database) => configureEncryptedDatabase(database, key: key),
      ),
    );

    var database = open();
    await database.storeProfiles(const <domain.StudentProfile>[
      domain.StudentProfile(
        sourceProfileId: 'source-profile-1',
        displayLabel: 'Profilo test',
        schoolMinistryCode: 'TEST0001',
        academicYear: '2026/2027',
      ),
    ]);
    final internalId = await database.internalProfileId('source-profile-1');
    final timestamp = DateTime.utc(2026, 9, 28, 12);
    await database.transaction(() async {
      await database.saveSyncBatch(
        internalProfileId: internalId,
        batch: domain.HomeworkBatch(
          homework: <domain.Homework>[
            domain.Homework(
              id: 'homework-1',
              profileId: internalId,
              sourceRecord: const domain.SourceRecordReference(
                sourcePrimaryKey: 'record-1',
                operation: domain.SourceRecordOperation.insertOrUpdate,
                recordDay: SchoolDate(2026, 9, 28),
              ),
              nestedIdentity: 'item-1',
              sourceItemId: 'item-1',
              identityConfidence:
                  domain.HomeworkIdentityConfidence.sourceIdentifier,
              origin: domain.HomeworkOrigin.argo,
              subject: const domain.SubjectReference(
                name: 'Matematica',
                sourceSubjectId: 'subject-1',
              ),
              text: 'Esercizi 1-5',
              assignedOn: const SchoolDate(2026, 9, 28),
              dueOn: const SchoolDate(2026, 9, 29),
              contentRevision: 'revision-1',
              firstSeenAt: timestamp,
              updatedAt: timestamp,
            ),
          ],
          deletedSourceRecordIds: const <String>[],
          directive: domain.SyncDirective.incremental,
          isPartial: false,
        ),
        attemptedAt: timestamp,
        coverageStart: DateTime.utc(2026, 9),
        adapterVersion: 'test-v1',
      );
    });
    final liveAgenda = StreamIterator(database.watchAgenda('source-profile-1'));
    expect(await liveAgenda.moveNext(), isTrue);
    expect(liveAgenda.current.single.isDone, isFalse);
    await database.setCompleted(
      sourceProfileId: 'source-profile-1',
      homeworkId: 'homework-1',
      isDone: true,
    );
    expect(await liveAgenda.moveNext(), isTrue);
    expect(liveAgenda.current.single.isDone, isTrue);
    await liveAgenda.cancel();
    await database.close();

    database = open();
    addTearDown(database.close);
    final restored = await database
        .watchAgenda('source-profile-1')
        .firstWhere((items) => items.isNotEmpty);

    expect(restored.single.text, 'Esercizi 1-5');
    expect(restored.single.isDone, isTrue);
    expect(restored.single.dueOn, const SchoolDate(2026, 9, 29));

    final bytes = await file.readAsBytes();
    expect(
      String.fromCharCodes(bytes.take(16)),
      isNot('SQLite format 3\u0000'),
    );
  });
}
