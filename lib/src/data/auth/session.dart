import '../../domain/auth/student_gender.dart';

final class DidupProfileSession {
  const DidupProfileSession({
    required this.sourceProfileId,
    required this.appAuthToken,
    required this.schoolMinistryCode,
    required this.notificationOptions,
    required this.displayLabel,
    this.gender = StudentGender.unknown,
    this.academicYear,
    this.academicYearStart,
  });

  final String sourceProfileId;
  final String appAuthToken;
  final String schoolMinistryCode;
  final Map<String, bool> notificationOptions;
  final String displayLabel;
  final StudentGender gender;
  final String? academicYear;
  final DateTime? academicYearStart;
}

final class DidupSession {
  const DidupSession({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.scopes,
    required this.expiresAt,
    required this.schoolCode,
    required this.username,
    required this.profiles,
    this.activeProfileId,
  });

  final String accessToken;
  final String? refreshToken;
  final String tokenType;
  final List<String> scopes;
  final DateTime? expiresAt;
  final String schoolCode;

  /// Necessario solo al rinnovo applicativo osservato; resta nel secure storage.
  final String username;
  final Map<String, DidupProfileSession> profiles;
  final String? activeProfileId;

  bool expiresWithin(DateTime now, Duration leeway) =>
      expiresAt != null && !expiresAt!.isAfter(now.add(leeway));

  DidupSession copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    List<String>? scopes,
    DateTime? expiresAt,
    String? activeProfileId,
  }) => DidupSession(
    accessToken: accessToken ?? this.accessToken,
    refreshToken: refreshToken ?? this.refreshToken,
    tokenType: tokenType ?? this.tokenType,
    scopes: scopes ?? this.scopes,
    expiresAt: expiresAt ?? this.expiresAt,
    schoolCode: schoolCode,
    username: username,
    profiles: profiles,
    activeProfileId: activeProfileId ?? this.activeProfileId,
  );
}
