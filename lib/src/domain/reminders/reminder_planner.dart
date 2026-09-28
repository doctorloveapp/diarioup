import '../agenda/homework_agenda_item.dart';
import '../homework/school_date.dart';
import 'reminder_plan.dart';
import 'reminder_preferences.dart';

abstract final class ReminderPlanner {
  static const int horizonDays = 14;
  static const int maximumNotifications = 32;

  static List<ReminderPlanEntry> build({
    required List<HomeworkAgendaItem> homework,
    required ReminderPreferences preferences,
    required DateTime now,
  }) {
    if (!preferences.enabled) return const <ReminderPlanEntry>[];
    final today = DateTime(now.year, now.month, now.day);
    final horizon = today.add(const Duration(days: horizonDays));
    final byDueDate = <SchoolDate, List<HomeworkAgendaItem>>{};

    for (final item in homework) {
      final dueOn = item.dueOn;
      if (item.isDone || dueOn == null) continue;
      final dueDate = dueOn.toLocalDate();
      if (!dueDate.isAfter(today) || dueDate.isAfter(horizon)) continue;
      byDueDate.putIfAbsent(dueOn, () => <HomeworkAgendaItem>[]).add(item);
    }

    final entries = <ReminderPlanEntry>[];
    for (final MapEntry(key: dueOn, value: items) in byDueDate.entries) {
      final reminderDate = dueOn.toLocalDate().subtract(
        const Duration(days: 1),
      );
      final scheduledAt = DateTime(
        reminderDate.year,
        reminderDate.month,
        reminderDate.day,
        preferences.hour,
        preferences.minute,
      );
      if (!scheduledAt.isAfter(now)) continue;
      entries.add(
        ReminderPlanEntry(
          notificationId:
              100000000 +
              (dueOn.year % 100) * 10000 +
              dueOn.month * 100 +
              dueOn.day,
          homeworkId: items.first.id,
          remindOn: SchoolDate(
            reminderDate.year,
            reminderDate.month,
            reminderDate.day,
          ),
          hour: preferences.hour,
          minute: preferences.minute,
        ),
      );
    }

    entries.sort((a, b) {
      final byDate = a.remindOn.compareTo(b.remindOn);
      return byDate != 0
          ? byDate
          : a.notificationId.compareTo(b.notificationId);
    });
    return entries.take(maximumNotifications).toList(growable: false);
  }
}
