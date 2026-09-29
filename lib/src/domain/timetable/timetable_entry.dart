enum SchoolWeekday {
  monday(1),
  tuesday(2),
  wednesday(3),
  thursday(4),
  friday(5);

  const SchoolWeekday(this.isoValue);

  final int isoValue;

  static SchoolWeekday fromIsoValue(int value) => values.firstWhere(
    (weekday) => weekday.isoValue == value,
    orElse: () => throw ArgumentError.value(value, 'value'),
  );
}

final class TimetableEntry {
  const TimetableEntry({
    required this.id,
    required this.profileId,
    required this.weekday,
    required this.period,
    required this.professorName,
    required this.updatedAt,
    this.subjectName,
    this.subjectColorValue,
  });

  final String id;
  final String profileId;
  final SchoolWeekday weekday;
  final int period;
  final String professorName;
  final String? subjectName;
  final int? subjectColorValue;
  final DateTime updatedAt;
}
