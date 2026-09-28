import 'dart:io';

import 'package:diarioup/diarioup.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

void main() {
  test(
    'elimina sessione, chiave, file personali, export e notifiche',
    () async {
      final documents = await Directory.systemTemp.createTemp(
        'diarioup-erase-documents-',
      );
      final temporary = await Directory.systemTemp.createTemp(
        'diarioup-erase-temporary-',
      );
      addTearDown(() async {
        if (await documents.exists()) await documents.delete(recursive: true);
        if (await temporary.exists()) await temporary.delete(recursive: true);
      });
      final personalization = Directory(
        '${documents.path}${Platform.pathSeparator}personalization',
      );
      final exports = Directory(
        '${temporary.path}${Platform.pathSeparator}diarioup_exports',
      );
      await personalization.create(recursive: true);
      await exports.create(recursive: true);
      await File('${personalization.path}/photo.jpg').writeAsBytes(<int>[1]);
      await File('${exports.path}/backup.json').writeAsBytes(<int>[2]);

      final database = AppDatabase(NativeDatabase.memory());
      final keyStore = _KeyStore();
      final sessionStore = MemorySessionStore();
      final reminderService = _ReminderService();
      var databaseFilesDeleted = false;
      final eraser = LocalAppDataEraser(
        database: database,
        deleteDatabaseFiles: () async => databaseFilesDeleted = true,
        databaseKeyStore: keyStore,
        sessionStore: sessionStore,
        reminderService: reminderService,
        documentsDirectoryLoader: () async => documents,
        temporaryDirectoryLoader: () async => temporary,
      );

      await eraser.eraseAll();

      expect(await personalization.exists(), isFalse);
      expect(await exports.exists(), isFalse);
      expect(sessionStore.clearCount, 1);
      expect(keyStore.clearCount, 1);
      expect(reminderService.cancelCount, 1);
      expect(databaseFilesDeleted, isTrue);
    },
  );
}

final class _KeyStore implements DatabaseKeyStore {
  var clearCount = 0;

  @override
  Future<void> clear() async => clearCount++;

  @override
  Future<String> loadOrCreate() async => 'synthetic-key';
}

final class _ReminderService implements ReminderService {
  var cancelCount = 0;

  @override
  Future<void> cancelAll() async => cancelCount++;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
