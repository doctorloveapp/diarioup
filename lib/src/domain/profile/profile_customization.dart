enum ProfileImageKind { profile, diaryBackground }

enum DiaryThemeMode { system, light, dark }

final class ProfileCustomization {
  const ProfileCustomization({
    this.profileImagePath,
    this.diaryBackgroundPath,
    this.themeMode = DiaryThemeMode.system,
    this.primaryColorValue,
    this.backgroundColorValue,
    this.checkUpdates = true,
  });

  final String? profileImagePath;
  final String? diaryBackgroundPath;
  final DiaryThemeMode themeMode;
  final int? primaryColorValue;
  final int? backgroundColorValue;
  final bool checkUpdates;

  String? pathFor(ProfileImageKind kind) => switch (kind) {
    ProfileImageKind.profile => profileImagePath,
    ProfileImageKind.diaryBackground => diaryBackgroundPath,
  };
}
