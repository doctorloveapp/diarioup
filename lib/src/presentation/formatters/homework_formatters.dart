import '../../domain/homework/school_date.dart';
import '../l10n/app_copy.dart';

String formatSchoolDate(SchoolDate? value) {
  if (value == null) return AppCopy.unavailableDate;
  return '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year}';
}

String homeworkCountdown(SchoolDate? dueOn, {DateTime? now}) {
  if (dueOn == null) return AppCopy.noDueDate;
  final current = now ?? DateTime.now();
  final today = DateTime(current.year, current.month, current.day);
  final due = dueOn.toLocalDate();
  final days = due.difference(today).inDays;
  return switch (days) {
    0 => AppCopy.dueToday,
    1 => AppCopy.dueTomorrow,
    -1 => AppCopy.overdueYesterday,
    < -1 => AppCopy.countdownPastDays(-days),
    _ => AppCopy.countdownInDays(days),
  };
}
