enum ProfileImageKind { profile, diaryBackground }

final class ProfileCustomization {
  const ProfileCustomization({this.profileImagePath, this.diaryBackgroundPath});

  final String? profileImagePath;
  final String? diaryBackgroundPath;

  String? pathFor(ProfileImageKind kind) => switch (kind) {
    ProfileImageKind.profile => profileImagePath,
    ProfileImageKind.diaryBackground => diaryBackgroundPath,
  };
}
