import '../homework/school_date.dart';

final class ManualHomeworkInput {
  const ManualHomeworkInput({
    required this.profileId,
    required this.text,
    this.subjectId,
    this.dueOn,
    this.personalNote,
  });

  final String profileId;
  final String text;
  final String? subjectId;
  final SchoolDate? dueOn;
  final String? personalNote;
}
