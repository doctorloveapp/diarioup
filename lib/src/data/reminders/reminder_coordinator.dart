import '../../domain/reminders/reminder_planner.dart';
import '../../domain/reminders/reminder_preferences.dart';
import '../../domain/reminders/reminder_service.dart';
import '../database/app_database.dart';

final class ReminderCoordinator {
  ReminderCoordinator({
    required AppDatabase database,
    required ReminderService service,
    DateTime Function()? now,
  }) : _database = database,
       _service = service,
       _now = now ?? DateTime.now;

  final AppDatabase _database;
  final ReminderService _service;
  final DateTime Function() _now;
  Future<void> _pending = Future<void>.value();

  Stream<ReminderPreferences> watchPreferences(String profileId) =>
      _database.watchReminderPreferences(profileId);

  Future<ReminderPermissionStatus> permissionStatus() async {
    await _service.initialize();
    return _service.permissionStatus();
  }

  Future<ReminderPermissionStatus> enable(String profileId) async {
    await _service.initialize();
    final status = await _service.requestPermission();
    if (status != ReminderPermissionStatus.granted) return status;
    final current = await _database.readReminderPreferences(profileId);
    await _database.writeReminderPreferences(
      profileId,
      current.copyWith(enabled: true),
    );
    await reschedule(profileId);
    return status;
  }

  Future<void> disable(String profileId) async {
    final current = await _database.readReminderPreferences(profileId);
    await _database.writeReminderPreferences(
      profileId,
      current.copyWith(enabled: false),
    );
    await cancelAll(profileId);
  }

  Future<void> updateTime({
    required String profileId,
    required int hour,
    required int minute,
  }) async {
    final current = await _database.readReminderPreferences(profileId);
    await _database.writeReminderPreferences(
      profileId,
      current.copyWith(hour: hour, minute: minute),
    );
    await reschedule(profileId);
  }

  Future<void> reschedule(String profileId) {
    final operation = _pending.then((_) => _reschedule(profileId));
    _pending = operation.then<void>((_) {}, onError: (_, _) {});
    return operation;
  }

  Future<void> _reschedule(String profileId) async {
    await _service.initialize();
    final preferences = await _database.readReminderPreferences(profileId);
    if (!preferences.enabled) {
      await cancelAll(profileId);
      return;
    }
    final permission = await _service.permissionStatus();
    if (permission != ReminderPermissionStatus.granted) {
      await _service.cancelAll();
      await _database.replaceReminderRecords(profileId, const []);
      return;
    }
    final homework = await _database.watchAgenda(profileId).first;
    final plan = ReminderPlanner.build(
      homework: homework,
      preferences: preferences,
      now: _now(),
    );
    await _service.replaceSchedule(plan);
    await _database.replaceReminderRecords(profileId, plan);
  }

  Future<void> cancelAll(String profileId) async {
    await _service.cancelAll();
    await _database.replaceReminderRecords(profileId, const []);
  }

  Future<bool> openNotificationSettings() =>
      _service.openNotificationSettings();
}
