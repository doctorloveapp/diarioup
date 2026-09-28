import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/agenda/homework_agenda_item.dart';
import '../../domain/agenda/manual_homework_input.dart';
import '../../domain/agenda/subject_agenda.dart';
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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) => migrator.createAll(),
    onUpgrade: (Migrator migrator, int from, int to) async {
      if (from < 2) {
        await migrator.addColumn(homeworkItems, homeworkItems.personalNote);
      }
      if (to > 2) {
        throw StateError('Migrazione database non definita: $from -> $to');
      }
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
              subjectId: subject?.id,
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
              origin: domain.HomeworkOrigin.values.byName(homework.origin),
              updatedAt: homework.updatedAt,
              personalNote: homework.personalNote,
            );
          })
          .toList(growable: false);
    });
  }

  Stream<HomeworkAgendaItem?> watchHomeworkDetail({
    required String sourceProfileId,
    required String homeworkId,
  }) => watchAgenda(
    sourceProfileId,
  ).map((items) => items.where((item) => item.id == homeworkId).firstOrNull);

  Stream<List<SubjectAgenda>> watchSubjects(String sourceProfileId) async* {
    final profile = await _profileBySourceId(sourceProfileId);
    if (profile == null) {
      yield const <SubjectAgenda>[];
      return;
    }
    final connection = await (select(
      argoConnections,
    )..where((table) => table.id.equals(profile.connectionId))).getSingle();
    final query = select(subjects).join(<Join<HasResultSet, Object?>>[
      leftOuterJoin(
        homeworkItems,
        homeworkItems.subjectId.equalsExp(subjects.id) &
            homeworkItems.sourceState.equals('active'),
      ),
      leftOuterJoin(
        completions,
        completions.homeworkId.equalsExp(homeworkItems.id) &
            completions.userId.equals(connection.userId),
      ),
    ])..where(subjects.profileId.equals(profile.id));

    yield* query.watch().map((rows) {
      final grouped = <String, _MutableSubjectAgenda>{};
      for (final row in rows) {
        final subject = row.readTable(subjects);
        final homework = row.readTableOrNull(homeworkItems);
        final completion = row.readTableOrNull(completions);
        final value = grouped.putIfAbsent(
          subject.id,
          () => _MutableSubjectAgenda(subject),
        );
        if (homework != null) {
          value.totalHomework++;
          if (completion?.isDone != true) value.pendingHomework++;
        }
      }
      final result =
          grouped.values
              .map(
                (value) => SubjectAgenda(
                  id: value.subject.id,
                  profileId: sourceProfileId,
                  name: value.subject.name,
                  colorValue: value.subject.colorValue,
                  totalHomework: value.totalHomework,
                  pendingHomework: value.pendingHomework,
                ),
              )
              .toList(growable: false)
            ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
            );
      return result;
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

  Future<void> updatePersonalNote({
    required String sourceProfileId,
    required String homeworkId,
    required String? note,
  }) async {
    final profile = await _profileBySourceId(sourceProfileId);
    if (profile == null) throw StateError('Profilo locale non inizializzato.');
    final normalized = note?.trim();
    final updated =
        await (update(homeworkItems)..where(
              (table) =>
                  table.id.equals(homeworkId) &
                  table.profileId.equals(profile.id) &
                  table.sourceState.equals('active'),
            ))
            .write(
              HomeworkItemsCompanion(
                personalNote: Value<String?>(
                  normalized == null || normalized.isEmpty ? null : normalized,
                ),
                updatedAt: Value<DateTime>(DateTime.now().toUtc()),
              ),
            );
    if (updated != 1) throw StateError('Compito locale non disponibile.');
  }

  Future<String> createManualSubject({
    required String sourceProfileId,
    required String name,
    required int colorValue,
  }) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError.value(
        name,
        'name',
        'La materia non può essere vuota.',
      );
    }
    final profile = await _profileBySourceId(sourceProfileId);
    if (profile == null) throw StateError('Profilo locale non inizializzato.');
    final existing = await (select(
      subjects,
    )..where((table) => table.profileId.equals(profile.id))).get();
    final duplicate = existing
        .where(
          (subject) =>
              subject.name.toLowerCase() == normalizedName.toLowerCase(),
        )
        .firstOrNull;
    if (duplicate != null) return duplicate.id;

    final id = _uuid.v4();
    await into(subjects).insert(
      SubjectsCompanion.insert(
        id: id,
        profileId: profile.id,
        academicYear: profile.academicYear,
        name: normalizedName,
        colorValue: Value<int?>(colorValue),
      ),
    );
    return id;
  }

  Future<String> createManualHomework(ManualHomeworkInput input) async {
    final normalizedText = input.text.trim();
    if (normalizedText.isEmpty) {
      throw ArgumentError.value(
        input.text,
        'text',
        'Il testo del compito non può essere vuoto.',
      );
    }
    final profile = await _profileBySourceId(input.profileId);
    if (profile == null) throw StateError('Profilo locale non inizializzato.');
    if (input.subjectId case final subjectId?) {
      final subject =
          await (select(subjects)..where(
                (table) =>
                    table.id.equals(subjectId) &
                    table.profileId.equals(profile.id),
              ))
              .getSingleOrNull();
      if (subject == null) throw StateError('Materia locale non disponibile.');
    }

    final id = _uuid.v4();
    final now = DateTime.now().toUtc();
    await transaction(() async {
      await into(homeworkItems).insert(
        HomeworkItemsCompanion.insert(
          id: id,
          profileId: profile.id,
          subjectId: Value<String?>(input.subjectId),
          nestedIdentity: id,
          identityConfidence:
              domain.HomeworkIdentityConfidence.localIdentifier.name,
          origin: domain.HomeworkOrigin.manual.name,
          body: normalizedText,
          personalNote: Value<String?>(_normalizedOptional(input.personalNote)),
          assignedOn: Value<String?>(_todaySchoolDate()),
          contentRevision: 'manual:$id',
          firstSeenAt: now,
          updatedAt: now,
        ),
      );
      await into(deadlines).insert(
        DeadlinesCompanion.insert(
          id: _uuid.v4(),
          homeworkId: id,
          personalDueOn: Value<String?>(input.dueOn?.toString()),
          provenance: const Value<String>('manual'),
        ),
      );
    });
    return id;
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
        personalNote: Value<String?>(previous?.personalNote),
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
        colorValue: Value<int?>(existing?.colorValue),
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

final class _MutableSubjectAgenda {
  _MutableSubjectAgenda(this.subject);

  final Subject subject;
  int totalHomework = 0;
  int pendingHomework = 0;
}

String? _normalizedOptional(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

String _todaySchoolDate() {
  final now = DateTime.now();
  return SchoolDate(now.year, now.month, now.day).toString();
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
