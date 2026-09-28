import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/reminders/reminder_plan.dart';
import '../../domain/reminders/reminder_service.dart';

final class LocalReminderService implements ReminderService {
  LocalReminderService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const String _channelId = 'homework_reminders_v1';
  static const String _channelName = 'Promemoria compiti';
  static const String _channelDescription =
      'Riepiloghi locali delle attività da controllare.';
  static const String _notificationTitle = 'DiarioUp';
  static const String _notificationBody =
      'Hai attività da controllare in DiarioUp';

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _initialization;
  late tz.Location _location;

  @override
  Future<void> initialize() => _initialization ??= _initialize();

  Future<void> _initialize() async {
    tz_data.initializeTimeZones();
    _location = await _deviceLocation();
    tz.setLocalLocation(_location);

    const android = AndroidInitializationSettings('ic_stat_diarioup');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
    );
  }

  Future<tz.Location> _deviceLocation() async {
    var timeZoneName = 'Europe/Rome';
    try {
      timeZoneName = (await FlutterTimezone.getLocalTimezone()).identifier;
    } on Object {
      // Europe/Rome è il fallback coerente con il calendario scolastico.
    }
    try {
      return tz.getLocation(timeZoneName);
    } on Object {
      return tz.getLocation('Europe/Rome');
    }
  }

  @override
  Future<ReminderPermissionStatus> permissionStatus() async {
    await initialize();
    if (kIsWeb) return ReminderPermissionStatus.unavailable;
    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final enabled = await android?.areNotificationsEnabled();
      return enabled == true
          ? ReminderPermissionStatus.granted
          : ReminderPermissionStatus.denied;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final options = await ios?.checkPermissions();
      return options?.isEnabled == true
          ? ReminderPermissionStatus.granted
          : ReminderPermissionStatus.denied;
    }
    return ReminderPermissionStatus.unavailable;
  }

  @override
  Future<ReminderPermissionStatus> requestPermission() async {
    await initialize();
    if (kIsWeb) return ReminderPermissionStatus.unavailable;
    if (defaultTargetPlatform == TargetPlatform.android) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      return granted == true
          ? ReminderPermissionStatus.granted
          : ReminderPermissionStatus.denied;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, sound: true, badge: false);
      return granted == true
          ? ReminderPermissionStatus.granted
          : ReminderPermissionStatus.denied;
    }
    return ReminderPermissionStatus.unavailable;
  }

  @override
  Future<bool> openNotificationSettings() async {
    await initialize();
    return await _plugin.openAppNotificationSettings() ?? false;
  }

  @override
  Future<void> replaceSchedule(List<ReminderPlanEntry> entries) async {
    await initialize();
    // Il fuso può cambiare mentre l'app rimane installata. Ogni ricalcolo usa
    // quindi il valore corrente del dispositivo, non quello del primo avvio.
    _location = await _deviceLocation();
    tz.setLocalLocation(_location);
    await _plugin.cancelAll();
    for (final entry in entries) {
      final scheduledDate = tz.TZDateTime(
        _location,
        entry.remindOn.year,
        entry.remindOn.month,
        entry.remindOn.day,
        entry.hour,
        entry.minute,
      );
      await _plugin.zonedSchedule(
        id: entry.notificationId,
        title: _notificationTitle,
        body: _notificationBody,
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            visibility: NotificationVisibility.private,
          ),
          iOS: DarwinNotificationDetails(
            threadIdentifier: 'homework_reminders',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'agenda',
      );
    }
  }

  @override
  Future<void> cancelAll() async {
    await initialize();
    await _plugin.cancelAll();
  }
}
