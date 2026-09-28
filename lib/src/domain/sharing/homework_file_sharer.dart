import 'dart:typed_data';

final class ShareSheetOrigin {
  const ShareSheetOrigin({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final double left;
  final double top;
  final double width;
  final double height;
}

abstract interface class HomeworkFileSharer {
  Future<void> sharePdf({
    required Uint8List bytes,
    required String fileName,
    ShareSheetOrigin? origin,
  });
}
