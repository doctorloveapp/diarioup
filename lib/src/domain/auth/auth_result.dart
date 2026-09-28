import 'student_profile.dart';

final class AuthResult {
  const AuthResult({required this.profiles});

  final List<StudentProfile> profiles;

  bool get requiresProfileSelection => profiles.length > 1;
}
