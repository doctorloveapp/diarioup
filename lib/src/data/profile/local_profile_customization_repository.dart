import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:image/image.dart' as image;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../domain/profile/profile_customization.dart';
import '../../domain/repositories/profile_customization_repository.dart';
import '../database/app_database.dart';

typedef DocumentsDirectoryProvider = Future<Directory> Function();

final class InvalidCustomizationImage implements Exception {
  const InvalidCustomizationImage();
}

final class LocalProfileCustomizationRepository
    implements ProfileCustomizationRepository {
  LocalProfileCustomizationRepository({
    required AppDatabase database,
    DocumentsDirectoryProvider documentsDirectoryProvider =
        getApplicationDocumentsDirectory,
  }) : _database = database,
       _documentsDirectoryProvider = documentsDirectoryProvider;

  static const int maximumInputBytes = 15 * 1024 * 1024;
  static const String _storageDirectory = 'personalization';

  final AppDatabase _database;
  final DocumentsDirectoryProvider _documentsDirectoryProvider;

  @override
  Stream<ProfileCustomization> watch(String profileId) =>
      _database.watchProfileCustomization(profileId);

  @override
  Future<Uint8List?> loadImage(String relativePath) async {
    final documents = await _documentsDirectoryProvider();
    final file = _safeFile(documents, relativePath);
    if (!await file.exists()) return null;
    return file.readAsBytes();
  }

  @override
  Future<void> saveImage({
    required String profileId,
    required ProfileImageKind kind,
    required Uint8List bytes,
  }) async {
    if (bytes.isEmpty || bytes.length > maximumInputBytes) {
      throw const InvalidCustomizationImage();
    }
    final processed = await Isolate.run<Uint8List>(
      () => _resizeAndEncode(bytes, kind),
    );
    final documents = await _documentsDirectoryProvider();
    final profileDirectoryName = sha256
        .convert(profileId.codeUnits)
        .toString()
        .substring(0, 20);
    final kindName = switch (kind) {
      ProfileImageKind.profile => 'profile',
      ProfileImageKind.diaryBackground => 'background',
    };
    final contentHash = sha256.convert(processed).toString().substring(0, 20);
    final relativePath = path.posix.join(
      _storageDirectory,
      profileDirectoryName,
      '$kindName-$contentHash.jpg',
    );
    final destination = _safeFile(documents, relativePath);
    await destination.parent.create(recursive: true);
    if (!await destination.exists()) {
      final temporary = File('${destination.path}.tmp');
      await temporary.writeAsBytes(processed, flush: true);
      await temporary.rename(destination.path);
    }

    final previous = await _database.readProfileCustomization(profileId);
    try {
      await _storePath(profileId, kind, relativePath);
    } on Object {
      if (previous.pathFor(kind) != relativePath) {
        await _deleteIfPresent(destination);
      }
      rethrow;
    }
    final previousPath = previous.pathFor(kind);
    if (previousPath != null && previousPath != relativePath) {
      await _deleteRelativeFile(documents, previousPath);
    }
  }

  @override
  Future<void> removeImage({
    required String profileId,
    required ProfileImageKind kind,
  }) async {
    final previous = await _database.readProfileCustomization(profileId);
    await _storePath(profileId, kind, null);
    final previousPath = previous.pathFor(kind);
    if (previousPath == null) return;
    final documents = await _documentsDirectoryProvider();
    await _deleteRelativeFile(documents, previousPath);
  }

  @override
  Future<void> saveAppearance({
    required String profileId,
    required DiaryThemeMode themeMode,
    required int primaryColorValue,
    required int backgroundColorValue,
  }) => _database.setProfileAppearance(
    profileId,
    themeMode: themeMode,
    primaryColorValue: primaryColorValue,
    backgroundColorValue: backgroundColorValue,
  );

  @override
  Future<void> saveCheckUpdates({
    required String profileId,
    required bool enabled,
  }) => _database.setCheckUpdates(profileId, enabled: enabled);

  Future<void> _storePath(
    String profileId,
    ProfileImageKind kind,
    String? relativePath,
  ) => switch (kind) {
    ProfileImageKind.profile => _database.setProfileImagePath(
      profileId,
      relativePath,
    ),
    ProfileImageKind.diaryBackground => _database.setDiaryBackgroundPath(
      profileId,
      relativePath,
    ),
  };

  Future<void> _deleteRelativeFile(
    Directory documents,
    String relativePath,
  ) async {
    try {
      await _deleteIfPresent(_safeFile(documents, relativePath));
    } on ArgumentError {
      // Un valore legacy non sicuro non deve consentire cancellazioni esterne.
    }
  }

  Future<void> _deleteIfPresent(File file) async {
    if (await file.exists()) await file.delete();
  }

  File _safeFile(Directory documents, String relativePath) {
    final normalizedRelative = path.posix.normalize(relativePath);
    if (path.posix.isAbsolute(normalizedRelative) ||
        path.windows.isAbsolute(relativePath) ||
        path.isAbsolute(relativePath) ||
        normalizedRelative == '..' ||
        normalizedRelative.startsWith('../')) {
      throw ArgumentError.value(relativePath, 'relativePath');
    }
    final segments = path.posix.split(normalizedRelative);
    final root = path.normalize(documents.absolute.path);
    final candidate = path.normalize(path.joinAll(<String>[root, ...segments]));
    if (!path.isWithin(root, candidate)) {
      throw ArgumentError.value(relativePath, 'relativePath');
    }
    return File(candidate);
  }

  static Uint8List _resizeAndEncode(Uint8List bytes, ProfileImageKind kind) {
    image.Image? decoded;
    try {
      decoded = image.decodeImage(bytes);
    } on Object {
      throw const InvalidCustomizationImage();
    }
    if (decoded == null) throw const InvalidCustomizationImage();
    final oriented = image.bakeOrientation(decoded);
    final maximumEdge = switch (kind) {
      ProfileImageKind.profile => 512,
      ProfileImageKind.diaryBackground => 1920,
    };
    final scale = math.min(
      1.0,
      math.min(maximumEdge / oriented.width, maximumEdge / oriented.height),
    );
    final resized = scale < 1
        ? image.copyResize(
            oriented,
            width: math.max(1, (oriented.width * scale).round()),
            height: math.max(1, (oriented.height * scale).round()),
            interpolation: image.Interpolation.average,
          )
        : oriented;
    return Uint8List.fromList(image.encodeJpg(resized, quality: 86));
  }
}
