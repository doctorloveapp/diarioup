final class SchoolDate implements Comparable<SchoolDate> {
  const SchoolDate(this.year, this.month, this.day)
    : assert(month >= 1 && month <= 12),
      assert(day >= 1 && day <= 31);

  final int year;
  final int month;
  final int day;

  DateTime toLocalDate() => DateTime(year, month, day);

  @override
  int compareTo(SchoolDate other) =>
      toLocalDate().compareTo(other.toLocalDate());

  @override
  bool operator ==(Object other) =>
      other is SchoolDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';
}
