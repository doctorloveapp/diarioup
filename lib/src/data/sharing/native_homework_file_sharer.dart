import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../domain/sharing/homework_file_sharer.dart';

typedef TemporaryDirectoryLoader = Future<Directory> Function();
typedef NativePdfShare =
    Future<void> Function({
      required String path,
      required String fileName,
      ShareSheetOrigin? origin,
    });

final class NativeHomeworkFileSharer implements HomeworkFileSharer {
  NativeHomeworkFileSharer({
    TemporaryDirectoryLoader? temporaryDirectoryLoader,
    NativePdfShare? nativeShare,
    String Function()? uniqueId,
  }) : _temporaryDirectoryLoader =
           temporaryDirectoryLoader ?? getTemporaryDirectory,
       _nativeShare = nativeShare ?? _shareWithPlatform,
       _uniqueId = uniqueId ?? const Uuid().v4;

  final TemporaryDirectoryLoader _temporaryDirectoryLoader;
  final NativePdfShare _nativeShare;
  final String Function() _uniqueId;

  @override
  Future<void> sharePdf({
    required Uint8List bytes,
    required String fileName,
    ShareSheetOrigin? origin,
  }) async {
    final temporaryDirectory = await _temporaryDirectoryLoader();
    final exportDirectory = Directory(
      path.join(temporaryDirectory.path, 'diarioup_exports'),
    );
    await exportDirectory.create(recursive: true);
    final temporaryFile = File(
      path.join(exportDirectory.path, '${_uniqueId()}.pdf'),
    );
    await temporaryFile.writeAsBytes(bytes, flush: true);

    try {
      await _nativeShare(
        path: temporaryFile.path,
        fileName: _safeFileName(fileName),
        origin: origin,
      );
    } finally {
      if (await temporaryFile.exists()) {
        await temporaryFile.delete();
      }
    }
  }

  static Future<void> _shareWithPlatform({
    required String path,
    required String fileName,
    ShareSheetOrigin? origin,
  }) async {
    final shareOrigin = origin == null
        ? null
        : Rect.fromLTWH(origin.left, origin.top, origin.width, origin.height);
    await SharePlus.instance.share(
      ShareParams(
        files: <XFile>[XFile(path, mimeType: 'application/pdf')],
        fileNameOverrides: <String>[fileName],
        title: 'Condividi i compiti',
        subject: 'Compiti DiarioUp',
        sharePositionOrigin: shareOrigin,
      ),
    );
  }

  String _safeFileName(String value) {
    final baseName = path.basename(value);
    final safeName = baseName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    return safeName.toLowerCase().endsWith('.pdf') ? safeName : '$safeName.pdf';
  }
}
