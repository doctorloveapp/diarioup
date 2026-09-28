// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart' hide isNull;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:diarioup/src/data/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test('migration from v1 to v2 does not corrupt data', () async {
    final timestamp = DateTime.utc(2026, 9, 28, 12);
    final oldUser = v1.LocalUsersData(
      id: 'user-1',
      locale: 'it',
      theme: 'system',
      timeZone: 'Europe/Rome',
      preferencesJson: '{}',
      createdAt: timestamp,
    );
    final oldConnection = v1.ArgoConnectionsData(
      id: 'connection-1',
      userId: oldUser.id,
      schoolMinistryCode: 'TEST0001',
      role: 'student',
      secretReference: 'secure-session-v1',
      sessionState: 'active',
      updatedAt: timestamp,
    );
    final oldProfile = v1.StudentProfilesData(
      id: 'profile-1',
      connectionId: oldConnection.id,
      sourceProfileId: 'source-profile-1',
      academicYear: '2026/2027',
      alias: 'Profilo test',
      updatedAt: timestamp,
    );
    final oldSubject = v1.SubjectsData(
      id: 'subject-1',
      profileId: oldProfile.id,
      academicYear: oldProfile.academicYear,
      name: 'Italiano',
      colorValue: 0xFF4F46E5,
    );
    final oldHomework = v1.HomeworkItemsData(
      id: 'homework-1',
      profileId: oldProfile.id,
      subjectId: oldSubject.id,
      nestedIdentity: 'manual:homework-1',
      identityConfidence: 'localIdentifier',
      origin: 'manual',
      body: 'Leggere il capitolo 3',
      assignedOn: '2026-09-28',
      contentRevision: 'revision-1',
      firstSeenAt: timestamp,
      updatedAt: timestamp,
      sourceState: 'active',
      requiresIdentityReview: false,
    );
    final oldCompletion = v1.CompletionsData(
      userId: oldUser.id,
      homeworkId: oldHomework.id,
      isDone: true,
      doneAt: timestamp,
      completedRevision: oldHomework.contentRevision,
      updatedAt: timestamp,
    );

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(oldDb.localUsers, oldUser);
        batch.insert(oldDb.argoConnections, oldConnection);
        batch.insert(oldDb.studentProfiles, oldProfile);
        batch.insert(oldDb.subjects, oldSubject);
        batch.insert(oldDb.homeworkItems, oldHomework);
        batch.insert(oldDb.completions, oldCompletion);
      },
      validateItems: (newDb) async {
        final homework = await newDb.select(newDb.homeworkItems).getSingle();
        final completion = await newDb.select(newDb.completions).getSingle();

        expect(homework.id, oldHomework.id);
        expect(homework.body, oldHomework.body);
        expect(homework.personalNote, isNull);
        expect(completion.homeworkId, oldHomework.id);
        expect(completion.isDone, isTrue);
        expect(completion.completedRevision, oldHomework.contentRevision);
      },
    );
  });
}
