import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

import '../../domain/profile/gallery_image_selector.dart';
import '../../domain/profile/profile_customization.dart';

final class ImagePickerGallerySelector implements GalleryImageSelector {
  ImagePickerGallerySelector({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<Uint8List?> select(ProfileImageKind kind) async {
    final maximumEdge = switch (kind) {
      ProfileImageKind.profile => 1024.0,
      ProfileImageKind.diaryBackground => 2560.0,
    };
    final selected = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: maximumEdge,
      maxHeight: maximumEdge,
      imageQuality: 90,
      requestFullMetadata: false,
    );
    return selected?.readAsBytes();
  }
}
