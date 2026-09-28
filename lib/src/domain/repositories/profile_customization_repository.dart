import 'dart:typed_data';

import '../profile/profile_customization.dart';

abstract interface class ProfileCustomizationRepository {
  Stream<ProfileCustomization> watch(String profileId);

  Future<Uint8List?> loadImage(String relativePath);

  Future<void> saveImage({
    required String profileId,
    required ProfileImageKind kind,
    required Uint8List bytes,
  });

  Future<void> removeImage({
    required String profileId,
    required ProfileImageKind kind,
  });
}
