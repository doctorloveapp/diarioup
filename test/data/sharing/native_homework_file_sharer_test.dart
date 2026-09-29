import 'dart:io';
import 'dart:typed_data';

import 'package:diarioup/diarioup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'il PDF temporaneo esiste durante la condivisione e viene eliminato',
    () async {
      final root = await Directory.systemTemp.createTemp('diarioup-share-');
      addTearDown(() async {
        if (await root.exists()) await root.delete(recursive: true);
      });
      String? sharedPath;
      String? sharedName;
      final sharer = NativeHomeworkFileSharer(
        temporaryDirectoryLoader: () async => root,
        uniqueId: () => 'export-test',
        nativeShare: ({required path, required fileName, origin}) async {
          sharedPath = path;
          sharedName = fileName;
          expect(File(path).uri.pathSegments.last, 'Compiti_privati.pdf');
          expect(await File(path).readAsBytes(), <int>[1, 2, 3, 4]);
        },
      );

      await sharer.sharePdf(
        bytes: Uint8List.fromList(<int>[1, 2, 3, 4]),
        fileName: '../Compiti privati.pdf',
      );

      expect(sharedName, 'Compiti_privati.pdf');
      expect(sharedPath, isNotNull);
      expect(await File(sharedPath!).exists(), isFalse);
    },
  );

  test(
    'elimina il PDF temporaneo anche se il foglio nativo fallisce',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'diarioup-share-error-',
      );
      addTearDown(() async {
        if (await root.exists()) await root.delete(recursive: true);
      });
      String? sharedPath;
      final sharer = NativeHomeworkFileSharer(
        temporaryDirectoryLoader: () async => root,
        uniqueId: () => 'export-error',
        nativeShare: ({required path, required fileName, origin}) async {
          sharedPath = path;
          throw StateError('errore sintetico');
        },
      );

      await expectLater(
        sharer.sharePdf(
          bytes: Uint8List.fromList(<int>[1, 2]),
          fileName: 'Compiti.pdf',
        ),
        throwsStateError,
      );
      expect(sharedPath, isNotNull);
      expect(await File(sharedPath!).exists(), isFalse);
    },
  );
}
