final class ReminderPreferences {
  const ReminderPreferences({
    this.enabled = false,
    this.hour = 18,
    this.minute = 0,
  }) : assert(hour >= 0 && hour <= 23),
       assert(minute >= 0 && minute <= 59);

  final bool enabled;
  final int hour;
  final int minute;

  ReminderPreferences copyWith({bool? enabled, int? hour, int? minute}) {
    return ReminderPreferences(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }
}
