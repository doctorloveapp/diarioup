import '../homework/school_date.dart';
import '../homework/homework.dart';

final class HomeworkAgendaItem {
  const HomeworkAgendaItem({
    required this.id,
    required this.profileId,
    required this.text,
    required this.isDone,
    required this.changedAfterCompletion,
    required this.requiresIdentityReview,
    required this.origin,
    required this.updatedAt,
    this.subjectId,
    this.subjectName,
    this.assignedOn,
    this.dueOn,
    this.doneAt,
    this.personalNote,
  });

  final String id;
  final String profileId;
  final String text;
  final String? subjectId;
  final String? subjectName;
  final SchoolDate? assignedOn;
  final SchoolDate? dueOn;
  final bool isDone;
  final DateTime? doneAt;
  final bool changedAfterCompletion;
  final bool requiresIdentityReview;
  final HomeworkOrigin origin;
  final DateTime updatedAt;
  final String? personalNote;
}
