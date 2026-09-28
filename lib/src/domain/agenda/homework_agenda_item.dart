import '../homework/school_date.dart';

final class HomeworkAgendaItem {
  const HomeworkAgendaItem({
    required this.id,
    required this.profileId,
    required this.text,
    required this.isDone,
    required this.changedAfterCompletion,
    required this.requiresIdentityReview,
    this.subjectName,
    this.assignedOn,
    this.dueOn,
    this.doneAt,
  });

  final String id;
  final String profileId;
  final String text;
  final String? subjectName;
  final SchoolDate? assignedOn;
  final SchoolDate? dueOn;
  final bool isDone;
  final DateTime? doneAt;
  final bool changedAfterCompletion;
  final bool requiresIdentityReview;
}
