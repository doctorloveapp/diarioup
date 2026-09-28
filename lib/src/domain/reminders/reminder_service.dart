import 'reminder_plan.dart';

enum ReminderPermissionStatus { granted, denied, unavailable }

abstract interface class ReminderService {
  Future<void> initialize();

  Future<ReminderPermissionStatus> permissionStatus();

  Future<ReminderPermissionStatus> requestPermission();

  Future<bool> openNotificationSettings();

  Future<void> replaceSchedule(List<ReminderPlanEntry> entries);

  Future<void> cancelAll();
}
