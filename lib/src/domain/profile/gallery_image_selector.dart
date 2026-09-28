import 'dart:typed_data';

import 'profile_customization.dart';

abstract interface class GalleryImageSelector {
  Future<Uint8List?> select(ProfileImageKind kind);
}
