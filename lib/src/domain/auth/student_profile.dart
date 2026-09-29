import 'student_gender.dart';

final class StudentProfile {
  const StudentProfile({
    required this.sourceProfileId,
    required this.displayLabel,
    this.gender = StudentGender.unknown,
    this.schoolMinistryCode,
    this.academicYear,
    this.academicYearStart,
  });

  final String sourceProfileId;
  final String displayLabel;
  final StudentGender gender;
  final String? schoolMinistryCode;
  final String? academicYear;
  final DateTime? academicYearStart;
}
