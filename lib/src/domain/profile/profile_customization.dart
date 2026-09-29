enum ProfileImageKind { profile, diaryBackground }

enum DiaryThemeMode { system, light, dark }

final class ProfileCustomization {
  const ProfileCustomization({
    this.profileImagePath,
    this.diaryBackgroundPath,
    this.themeMode = DiaryThemeMode.system,
    this.primaryColorValue,
    this.backgroundColorValue,
  });

  final String? profileImagePath;
  final String? diaryBackgroundPath;
  final DiaryThemeMode themeMode;
  final int? primaryColorValue;
  final int? backgroundColorValue;

  String? pathFor(ProfileImageKind kind) => switch (kind) {
    ProfileImageKind.profile => profileImagePath,
    ProfileImageKind.diaryBackground => diaryBackgroundPath,
  };
}
