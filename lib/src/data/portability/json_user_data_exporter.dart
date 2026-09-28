import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repositories/didup_repository.dart';
import '../../domain/portability/user_data_exporter.dart';
import '../../domain/sharing/homework_file_sharer.dart';

typedef NativeJsonShare =
    Future<void> Function({
      required String path,
      required String fileName,
      ShareSheetOrigin? origin,
    });

final class JsonUserDataExporter implements UserDataExporter {
  JsonUserDataExporter({
    required DidupRepository repository,
    required String appVersion,
    Future<Directory> Function()? temporaryDirectoryLoader,
    NativeJsonShare? nativeShare,
    DateTime Function()? now,
    String Function()? uniqueId,
  }) : _repository = repository,
       _appVersion = appVersion,
       _temporaryDirectoryLoader =
           temporaryDirectoryLoader ?? getTemporaryDirectory,
       _nativeShare = nativeShare ?? _shareWithPlatform,
       _now = now ?? DateTime.now,
       _uniqueId = uniqueId ?? const Uuid().v4;

  final DidupRepository _repository;
  final String _appVersion;
  final Future<Directory> Function() _temporaryDirectoryLoader;
  final NativeJsonShare _nativeShare;
  final DateTime Function() _now;
  final String Function() _uniqueId;

  @override
  Future<int> exportJson({
    required String profileId,
    ShareSheetOrigin? origin,
  }) async {
    final homework = await _repository
        .watchHomework(profileId: profileId)
        .first;
    final generatedAt = _now().toUtc();
    final payload = <String, Object?>{
      'format': 'diarioup-homework-backup',
      'schemaVersion': 1,
      'appVersion': _appVersion,
      'exportedAt': generatedAt.toIso8601String(),
      'homework': homework
          .map(
            (item) => <String, Object?>{
              'id': item.id,
              'subject': item.subjectName,
              'text': item.text,
              'assignedOn': item.assignedOn?.toString(),
              'dueOn': item.dueOn?.toString(),
              'completed': item.isDone,
              'completedAt': item.doneAt?.toUtc().toIso8601String(),
              'personalNote': item.personalNote,
              'origin': item.origin.name,
              'updatedAt': item.updatedAt.toUtc().toIso8601String(),
            },
          )
          .toList(growable: false),
    };
    final bytes = utf8.encode(
      const JsonEncoder.withIndent('  ').convert(payload),
    );
    final temporaryRoot = await _temporaryDirectoryLoader();
    final exportDirectory = Directory(
      path.join(temporaryRoot.path, 'diarioup_exports'),
    );
    await exportDirectory.create(recursive: true);
    final temporaryFile = File(
      path.join(exportDirectory.path, '${_uniqueId()}.json'),
    );
    await temporaryFile.writeAsBytes(bytes, flush: true);
    try {
      await _nativeShare(
        path: temporaryFile.path,
        fileName: _fileName(generatedAt),
        origin: origin,
      );
    } finally {
      if (await temporaryFile.exists()) await temporaryFile.delete();
    }
    return homework.length;
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
        files: <XFile>[XFile(path, mimeType: 'application/json')],
        fileNameOverrides: <String>[fileName],
        title: 'Esporta dati DiarioUp',
        subject: 'Backup DiarioUp',
        sharePositionOrigin: shareOrigin,
      ),
    );
  }

  String _fileName(DateTime generatedAt) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return 'DiarioUp-backup-'
        '${generatedAt.year}${twoDigits(generatedAt.month)}'
        '${twoDigits(generatedAt.day)}-'
        '${twoDigits(generatedAt.hour)}${twoDigits(generatedAt.minute)}.json';
  }
}
