import 'school_date.dart';

enum HomeworkOrigin { argo, manual }

enum HomeworkIdentityConfidence {
  sourceIdentifier,
  persistentParentMapping,
  localIdentifier,
}

enum SourceRecordOperation { insertOrUpdate, delete }

enum SyncDirective { incremental, rebuildSourceCache, reload, profileDisabled }

final class SubjectReference {
  const SubjectReference({required this.name, this.sourceSubjectId});

  final String? sourceSubjectId;
  final String name;
}

final class SourceRecordReference {
  const SourceRecordReference({
    required this.sourcePrimaryKey,
    required this.operation,
    required this.recordDay,
    this.revision,
  });

  final String sourcePrimaryKey;
  final String? revision;
  final SourceRecordOperation operation;
  final SchoolDate? recordDay;
}

final class Homework {
  const Homework({
    required this.id,
    required this.profileId,
    required this.sourceRecord,
    required this.nestedIdentity,
    required this.identityConfidence,
    required this.origin,
    required this.text,
    required this.contentRevision,
    required this.firstSeenAt,
    required this.updatedAt,
    this.sourceItemId,
    this.subject,
    this.assignedOn,
    this.dueOn,
    this.requiresIdentityReview = false,
  });

  final String id;
  final String profileId;
  final SourceRecordReference sourceRecord;
  final String nestedIdentity;
  final String? sourceItemId;
  final HomeworkIdentityConfidence identityConfidence;
  final HomeworkOrigin origin;
  final SubjectReference? subject;
  final String text;
  final SchoolDate? assignedOn;
  final SchoolDate? dueOn;
  final String contentRevision;
  final DateTime firstSeenAt;
  final DateTime updatedAt;
  final bool requiresIdentityReview;
}

final class HomeworkBatch {
  const HomeworkBatch({
    required this.homework,
    required this.deletedSourceRecordIds,
    required this.directive,
    required this.isPartial,
  });

  final List<Homework> homework;
  final List<String> deletedSourceRecordIds;
  final SyncDirective directive;
  final bool isPartial;
}
