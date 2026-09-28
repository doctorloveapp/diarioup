import 'package:drift/drift.dart';

class LocalUsers extends Table {
  TextColumn get id => text()();
  TextColumn get locale => text().withDefault(const Constant('it'))();
  TextColumn get theme => text().withDefault(const Constant('system'))();
  TextColumn get timeZone =>
      text().withDefault(const Constant('Europe/Rome'))();
  TextColumn get preferencesJson => text().withDefault(const Constant('{}'))();
  TextColumn get privacyNoticeVersion => text().nullable()();
  TextColumn get ageBand => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

class ArgoConnections extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(LocalUsers, #id)();
  TextColumn get schoolMinistryCode => text()();
  TextColumn get role => text().withDefault(const Constant('family'))();
  TextColumn get secretReference => text()();
  TextColumn get sessionState => text().withDefault(const Constant('active'))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => <Set<Column<Object>>>[
    <Column<Object>>{userId, schoolMinistryCode},
  ];
}

@TableIndex(
  name: 'profiles_by_connection_year',
  columns: {#connectionId, #academicYear},
)
class StudentProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get connectionId => text().references(ArgoConnections, #id)();
  TextColumn get sourceProfileId => text()();
  TextColumn get academicYear => text()();
  TextColumn get alias => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => <Set<Column<Object>>>[
    <Column<Object>>{connectionId, sourceProfileId},
  ];
}

@TableIndex(
  name: 'subjects_by_profile_year',
  columns: {#profileId, #academicYear},
)
class Subjects extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().references(StudentProfiles, #id)();
  TextColumn get academicYear => text()();
  TextColumn get sourceSubjectId => text().nullable()();
  TextColumn get name => text()();
  IntColumn get colorValue => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => <Set<Column<Object>>>[
    <Column<Object>>{profileId, academicYear, name},
  ];
}

@TableIndex(
  name: 'source_records_by_profile_day',
  columns: {#profileId, #recordDay},
)
class SourceRecords extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().references(StudentProfiles, #id)();
  TextColumn get sourcePrimaryKey => text()();
  TextColumn get revision => text().nullable()();
  TextColumn get state => text().withDefault(const Constant('active'))();
  TextColumn get recordDay => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => <Set<Column<Object>>>[
    <Column<Object>>{profileId, sourcePrimaryKey},
  ];
}

@TableIndex(
  name: 'homework_by_profile_state',
  columns: {#profileId, #sourceState},
)
@TableIndex(
  name: 'homework_by_profile_subject',
  columns: {#profileId, #subjectId},
)
class HomeworkItems extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().references(StudentProfiles, #id)();
  TextColumn get sourceRecordId =>
      text().nullable().references(SourceRecords, #id)();
  TextColumn get subjectId => text().nullable().references(Subjects, #id)();
  TextColumn get nestedIdentity => text()();
  TextColumn get sourceItemId => text().nullable()();
  TextColumn get identityConfidence => text()();
  TextColumn get origin => text()();
  TextColumn get body => text()();
  TextColumn get assignedOn => text().nullable()();
  TextColumn get contentRevision => text()();
  DateTimeColumn get firstSeenAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get sourceState => text().withDefault(const Constant('active'))();
  BoolColumn get requiresIdentityReview =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@TableIndex(name: 'deadlines_by_source_due', columns: {#sourceDueOn})
@TableIndex(name: 'deadlines_by_personal_due', columns: {#personalDueOn})
class Deadlines extends Table {
  TextColumn get id => text()();
  TextColumn get homeworkId => text().unique().references(HomeworkItems, #id)();
  TextColumn get sourceDueOn => text().nullable()();
  TextColumn get personalDueOn => text().nullable()();
  TextColumn get sourceTime => text().nullable()();
  TextColumn get schoolTimeZone =>
      text().withDefault(const Constant('Europe/Rome'))();
  TextColumn get precision => text().withDefault(const Constant('date'))();
  TextColumn get provenance => text().withDefault(const Constant('argo'))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

class Completions extends Table {
  TextColumn get userId => text().references(LocalUsers, #id)();
  TextColumn get homeworkId => text().references(HomeworkItems, #id)();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  DateTimeColumn get doneAt => dateTime().nullable()();
  TextColumn get completedRevision => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{userId, homeworkId};
}

class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(LocalUsers, #id)();
  TextColumn get homeworkId => text().references(HomeworkItems, #id)();
  DateTimeColumn get remindAt => dateTime()();
  TextColumn get state => text().withDefault(const Constant('scheduled'))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

class SyncStates extends Table {
  TextColumn get profileId => text().references(StudentProfiles, #id)();
  TextColumn get adapterVersion => text()();
  TextColumn get cursor => text().nullable()();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  DateTimeColumn get lastSuccessAt => dateTime().nullable()();
  DateTimeColumn get coverageStart => dateTime().nullable()();
  TextColumn get errorCode => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{profileId};
}

class HomeworkIdentityMappings extends Table {
  TextColumn get profileId => text().references(StudentProfiles, #id)();
  TextColumn get sourceRecordId => text()();
  TextColumn get nestedIdentity => text()();
  TextColumn get homeworkId => text()();
  TextColumn get contentRevision => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{
    profileId,
    sourceRecordId,
    nestedIdentity,
  };
}
