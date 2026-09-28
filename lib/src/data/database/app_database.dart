import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/agenda/homework_agenda_item.dart';
import '../../domain/auth/student_profile.dart' as domain;
import '../../domain/homework/homework.dart' as domain;
import '../../domain/homework/school_date.dart';
import '../../domain/sync/didup_sync.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: <Type>[
    LocalUsers,
    ArgoConnections,
    StudentProfiles,
    Subjects,
    SourceRecords,
    HomeworkItems,
    Deadlines,
    Completions,
    Reminders,
    SyncStates,
    HomeworkIdentityMappings,
  ],
)
final class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) => migrator.createAll(),
    onUpgrade: (Migrator migrator, int from, int to) async {
      throw StateError('Migrazione database non definita: $from -> $to');
    },
    beforeOpen: (OpeningDetails details) async {
      await customStatement('pragma foreign_keys = on');
      if (details.wasCreated || details.hadUpgrade) {
        final violations = await customSelect('pragma foreign_key_check').get();
        if (violations.isNotEmpty) {
          throw StateError(
            'Vincoli del database non validi dopo la migrazione.',
          );
        }
      }
    },
  );

  Future<void> storeProfiles(List<domain.StudentProfile> profiles) async {
    final now = DateTime.now().toUtc();
    await transaction(() async {
      for (final profile in profiles) {
        final schoolCode = profile.schoolMinistryCode?.trim();
        final academicYear = profile.academicYear?.trim();
        final connection = await _connectionForSchool(
          schoolCode == null || schoolCode.isEmpty ? 'unknown' : schoolCode,
        );
        final connectionId = connection?.id ?? _uuid.v4();
        final userId = connection?.userId ?? _uuid.v4();
        if (connection == null) {
          await into(
            localUsers,
          ).insert(LocalUsersCompanion.insert(id: userId, createdAt: now));
          await into(argoConnections).insert(
            ArgoConnectionsCompanion.insert(
              id: connectionId,
              userId: userId,
              schoolMinistryCode: schoolCode == null || schoolCode.isEmpty
                  ? 'unknown'
                  : schoolCode,
              secretReference: 'secure-session-v1',
              updatedAt: now,
            ),
          );
        }
        final existing = await _profileBySourceId(profile.sourceProfileId);
        await into(studentProfiles).insertOnConflictUpdate(
          StudentProfilesCompanion.insert(
            id: existing?.id ?? _uuid.v4(),
            connectionId: connectionId,
            sourceProfileId: profile.sourceProfileId,
            academicYear: academicYear == null || academicYear.isEmpty
                ? 'unknown'
                : academicYear,
            alias: profile.displayLabel,
            updatedAt: now,
          ),
        );
      }
    });
  }

  Future<String> internalProfileId(String sourceProfileId) async {
    final profile = await _profileBySourceId(sourceProfileId);
    if (profile == null) {
      throw StateError('Profilo locale non inizializzato.');
    }
    return profile.id;
  }

  Future<DateTime?> lastSuccessfulSync(String internalProfileId) async {
    final state =
        await (select(syncStates)
              ..where((table) => table.profileId.equals(internalProfileId)))
            .getSingleOrNull();
    return state?.lastSuccessAt;
  }

  Future<void> saveSyncBatch({
    required String internalProfileId,
    required domain.HomeworkBatch batch,
    required DateTime attemptedAt,
    required DateTime coverageStart,
    required String adapterVersion,
  }) async {
    if (batch.directive == domain.SyncDirective.profileDisabled) {
      await _markProfileSourceItemsDeleted(internalProfileId);
    } else {
      if ((batch.directive == domain.SyncDirective.rebuildSourceCache ||
              batch.directive == domain.SyncDirective.reload) &&
          !batch.isPartial) {
        await _markProfileSourceItemsDeleted(internalProfileId);
      }
      await _markDeletedRecords(
        internalProfileId,
        batch.deletedSourceRecordIds,
      );
      for (final homework in batch.homework) {
        await _upsertHomework(internalProfileId, homework);
      }
    }

    await into(syncStates).insertOnConflictUpdate(
      SyncStatesCompanion.insert(
        profileId: internalProfileId,
        adapterVersion: adapterVersion,
        cursor: Value<String?>(attemptedAt.toIso8601String()),
        lastAttemptAt: Value<DateTime?>(attemptedAt),
        lastSuccessAt: Value<DateTime?>(attemptedAt),
        coverageStart: Value<DateTime?>(coverageStart),
        errorCode: const Value<String?>(null),
      ),
    );
  }

  Future<void> recordSyncFailure({
    required String internalProfileId,
    required DateTime attemptedAt,
    required String adapterVersion,
    required String errorCode,
  }) async {
    final previous =
        await (select(syncStates)
              ..where((table) => table.profileId.equals(internalProfileId)))
            .getSingleOrNull();
    await into(syncStates).insertOnConflictUpdate(
      SyncStatesCompanion.insert(
        profileId: internalProfileId,
        adapterVersion: adapterVersion,
        cursor: Value<String?>(previous?.cursor),
        lastAttemptAt: Value<DateTime?>(attemptedAt),
        lastSuccessAt: Value<DateTime?>(previous?.lastSuccessAt),
        coverageStart: Value<DateTime?>(previous?.coverageStart),
        errorCode: Value<String?>(errorCode),
      ),
    );
  }

  Stream<List<HomeworkAgendaItem>> watchAgenda(String sourceProfileId) async* {
    final profile = await _profileBySourceId(sourceProfileId);
    if (profile == null) {
      yield const <HomeworkAgendaItem>[];
      return;
    }
    final connection = await (select(
      argoConnections,
    )..where((table) => table.id.equals(profile.connectionId))).getSingle();
    final query =
        select(homeworkItems).join(<Join<HasResultSet, Object?>>[
            leftOuterJoin(
              subjects,
              subjects.id.equalsExp(homeworkItems.subjectId),
            ),
            leftOuterJoin(
              deadlines,
              deadlines.homeworkId.equalsExp(homeworkItems.id),
            ),
            leftOuterJoin(
              completions,
              completions.homeworkId.equalsExp(homeworkItems.id) &
                  completions.userId.equals(connection.userId),
            ),
          ])
          ..where(
            homeworkItems.profileId.equals(profile.id) &
                homeworkItems.sourceState.equals('active'),
          )
          ..orderBy(<OrderingTerm>[
            OrderingTerm.asc(deadlines.sourceDueOn),
            OrderingTerm.asc(homeworkItems.updatedAt),
          ]);

    yield* query.watch().map((rows) {
      return rows
          .map((row) {
            final homework = row.readTable(homeworkItems);
            final subject = row.readTableOrNull(subjects);
            final deadline = row.readTableOrNull(deadlines);
            final completion = row.readTableOrNull(completions);
            return HomeworkAgendaItem(
              id: homework.id,
              profileId: sourceProfileId,
              text: homework.body,
              subjectName: subject?.name,
              assignedOn: _schoolDate(homework.assignedOn),
              dueOn: _schoolDate(
                deadline?.personalDueOn ?? deadline?.sourceDueOn,
              ),
              isDone: completion?.isDone ?? false,
              doneAt: completion?.doneAt,
              changedAfterCompletion:
                  completion?.isDone == true &&
                  completion?.completedRevision != homework.contentRevision,
              requiresIdentityReview: homework.requiresIdentityReview,
            );
          })
          .toList(growable: false);
    });
  }

  Stream<DidupSyncStatus?> watchSyncStatus(String sourceProfileId) async* {
    final profile = await _profileBySourceId(sourceProfileId);
    if (profile == null) {
      yield null;
      return;
    }
    yield* (select(syncStates)
          ..where((table) => table.profileId.equals(profile.id)))
        .watchSingleOrNull()
        .map(
          (state) => state == null
              ? null
              : DidupSyncStatus(
                  profileId: sourceProfileId,
                  lastAttemptAt: state.lastAttemptAt,
                  lastSuccessAt: state.lastSuccessAt,
                  coverageStart: state.coverageStart,
                  errorCode: state.errorCode,
                ),
        );
  }

  Future<void> setCompleted({
    required String sourceProfileId,
    required String homeworkId,
    required bool isDone,
  }) async {
    final profile = await _profileBySourceId(sourceProfileId);
    if (profile == null) throw StateError('Profilo locale non inizializzato.');
    final connection = await (select(
      argoConnections,
    )..where((table) => table.id.equals(profile.connectionId))).getSingle();
    final homework =
        await (select(homeworkItems)..where(
              (table) =>
                  table.id.equals(homeworkId) &
                  table.profileId.equals(profile.id),
            ))
            .getSingle();
    final now = DateTime.now().toUtc();
    await into(completions).insertOnConflictUpdate(
      CompletionsCompanion.insert(
        userId: connection.userId,
        homeworkId: homework.id,
        isDone: Value<bool>(isDone),
        doneAt: Value<DateTime?>(isDone ? now : null),
        completedRevision: Value<String?>(
          isDone ? homework.contentRevision : null,
        ),
        updatedAt: now,
      ),
    );
  }

  Future<void> _upsertHomework(
    String internalProfileId,
    domain.Homework homework,
  ) async {
    final sourceRecord = await _upsertSourceRecord(internalProfileId, homework);
    final subjectId = await _upsertSubject(internalProfileId, homework.subject);
    final previous = await (select(
      homeworkItems,
    )..where((table) => table.id.equals(homework.id))).getSingleOrNull();
    await into(homeworkItems).insertOnConflictUpdate(
      HomeworkItemsCompanion.insert(
        id: homework.id,
        profileId: internalProfileId,
        sourceRecordId: Value<String?>(sourceRecord),
        subjectId: Value<String?>(subjectId),
        nestedIdentity: homework.nestedIdentity,
        sourceItemId: Value<String?>(homework.sourceItemId),
        identityConfidence: homework.identityConfidence.name,
        origin: homework.origin.name,
        body: homework.text,
        assignedOn: Value<String?>(homework.assignedOn?.toString()),
        contentRevision: homework.contentRevision,
        firstSeenAt: previous?.firstSeenAt ?? homework.firstSeenAt,
        updatedAt: homework.updatedAt,
        sourceState: const Value<String>('active'),
        requiresIdentityReview: Value<bool>(homework.requiresIdentityReview),
      ),
    );
    final deadline =
        await (select(deadlines)
              ..where((table) => table.homeworkId.equals(homework.id)))
            .getSingleOrNull();
    await into(deadlines).insertOnConflictUpdate(
      DeadlinesCompanion.insert(
        id: deadline?.id ?? _uuid.v4(),
        homeworkId: homework.id,
        sourceDueOn: Value<String?>(homework.dueOn?.toString()),
      ),
    );
  }

  Future<String> _upsertSourceRecord(
    String internalProfileId,
    domain.Homework homework,
  ) async {
    final existing =
        await (select(sourceRecords)..where(
              (table) =>
                  table.profileId.equals(internalProfileId) &
                  table.sourcePrimaryKey.equals(
                    homework.sourceRecord.sourcePrimaryKey,
                  ),
            ))
            .getSingleOrNull();
    final id = existing?.id ?? _uuid.v4();
    await into(sourceRecords).insertOnConflictUpdate(
      SourceRecordsCompanion.insert(
        id: id,
        profileId: internalProfileId,
        sourcePrimaryKey: homework.sourceRecord.sourcePrimaryKey,
        revision: Value<String?>(homework.sourceRecord.revision),
        state: const Value<String>('active'),
        recordDay: Value<String?>(homework.sourceRecord.recordDay?.toString()),
        updatedAt: homework.updatedAt,
      ),
    );
    return id;
  }

  Future<String?> _upsertSubject(
    String internalProfileId,
    domain.SubjectReference? subject,
  ) async {
    if (subject == null) return null;
    final profile = await (select(
      studentProfiles,
    )..where((table) => table.id.equals(internalProfileId))).getSingle();
    final query = select(subjects)
      ..where(
        (table) =>
            table.profileId.equals(internalProfileId) &
            (subject.sourceSubjectId == null
                ? table.name.equals(subject.name)
                : table.sourceSubjectId.equals(subject.sourceSubjectId!)),
      );
    final existing = await query.getSingleOrNull();
    final id = existing?.id ?? _uuid.v4();
    await into(subjects).insertOnConflictUpdate(
      SubjectsCompanion.insert(
        id: id,
        profileId: internalProfileId,
        academicYear: profile.academicYear,
        sourceSubjectId: Value<String?>(subject.sourceSubjectId),
        name: subject.name,
      ),
    );
    return id;
  }

  Future<void> _markDeletedRecords(
    String profileId,
    List<String> sourcePrimaryKeys,
  ) async {
    if (sourcePrimaryKeys.isEmpty) return;
    final records =
        await (select(sourceRecords)..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.sourcePrimaryKey.isIn(sourcePrimaryKeys),
            ))
            .get();
    final ids = records.map((record) => record.id).toList(growable: false);
    if (ids.isEmpty) return;
    await (update(sourceRecords)..where((table) => table.id.isIn(ids))).write(
      const SourceRecordsCompanion(state: Value<String>('deleted')),
    );
    await (update(
      homeworkItems,
    )..where((table) => table.sourceRecordId.isIn(ids))).write(
      const HomeworkItemsCompanion(sourceState: Value<String>('deleted')),
    );
  }

  Future<void> _markProfileSourceItemsDeleted(String profileId) async {
    await (update(sourceRecords)
          ..where((table) => table.profileId.equals(profileId)))
        .write(const SourceRecordsCompanion(state: Value<String>('deleted')));
    await (update(homeworkItems)..where(
          (table) =>
              table.profileId.equals(profileId) & table.origin.equals('argo'),
        ))
        .write(
          const HomeworkItemsCompanion(sourceState: Value<String>('deleted')),
        );
  }

  Future<ArgoConnection?> _connectionForSchool(String schoolCode) =>
      (select(argoConnections)
            ..where((table) => table.schoolMinistryCode.equals(schoolCode)))
          .getSingleOrNull();

  Future<StudentProfile?> _profileBySourceId(String sourceProfileId) =>
      (select(studentProfiles)
            ..where((table) => table.sourceProfileId.equals(sourceProfileId)))
          .getSingleOrNull();
}

SchoolDate? _schoolDate(String? value) {
  if (value == null) return null;
  final parts = value.split('-');
  if (parts.length != 3) return null;
  return SchoolDate(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}
