final class StudentProfile {
  const StudentProfile({
    required this.sourceProfileId,
    required this.displayLabel,
    this.schoolMinistryCode,
    this.academicYear,
    this.academicYearStart,
  });

  final String sourceProfileId;
  final String displayLabel;
  final String? schoolMinistryCode;
  final String? academicYear;
  final DateTime? academicYearStart;
}
