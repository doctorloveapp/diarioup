import '../homework/school_date.dart';

final class ReminderPlanEntry {
  const ReminderPlanEntry({
    required this.notificationId,
    required this.homeworkId,
    required this.remindOn,
    required this.hour,
    required this.minute,
  });

  final int notificationId;
  final String homeworkId;
  final SchoolDate remindOn;
  final int hour;
  final int minute;
}
