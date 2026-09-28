import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../domain/privacy/app_data_eraser.dart';
import '../../domain/reminders/reminder_service.dart';
import '../auth/session_store.dart';
import '../database/app_database.dart';
import '../database/database_key_store.dart';

final class AppDataErasureFailure implements Exception {
  const AppDataErasureFailure();
}

final class LocalAppDataEraser implements AppDataEraser {
  LocalAppDataEraser({
    required AppDatabase database,
    required Future<void> Function() deleteDatabaseFiles,
    required DatabaseKeyStore databaseKeyStore,
    required SessionStore sessionStore,
    required ReminderService reminderService,
    Future<Directory> Function()? documentsDirectoryLoader,
    Future<Directory> Function()? temporaryDirectoryLoader,
  }) : _database = database,
       _deleteDatabaseFiles = deleteDatabaseFiles,
       _databaseKeyStore = databaseKeyStore,
       _sessionStore = sessionStore,
       _reminderService = reminderService,
       _documentsDirectoryLoader =
           documentsDirectoryLoader ?? getApplicationDocumentsDirectory,
       _temporaryDirectoryLoader =
           temporaryDirectoryLoader ?? getTemporaryDirectory;

  final AppDatabase _database;
  final Future<void> Function() _deleteDatabaseFiles;
  final DatabaseKeyStore _databaseKeyStore;
  final SessionStore _sessionStore;
  final ReminderService _reminderService;
  final Future<Directory> Function() _documentsDirectoryLoader;
  final Future<Directory> Function() _temporaryDirectoryLoader;

  @override
  Future<void> eraseAll() async {
    var failed = false;

    Future<void> attempt(Future<void> Function() action) async {
      try {
        await action();
      } on Object {
        failed = true;
      }
    }

    await attempt(_reminderService.cancelAll);
    await attempt(_sessionStore.clear);
    await attempt(() async {
      final documents = await _documentsDirectoryLoader();
      await _deleteChildDirectory(documents, 'personalization');
    });
    await attempt(() async {
      final temporary = await _temporaryDirectoryLoader();
      await _deleteChildDirectory(temporary, 'diarioup_exports');
    });
    await attempt(_database.close);
    await attempt(_deleteDatabaseFiles);
    await attempt(_databaseKeyStore.clear);

    if (failed) throw const AppDataErasureFailure();
  }

  Future<void> _deleteChildDirectory(Directory root, String childName) async {
    final normalizedRoot = path.normalize(root.absolute.path);
    final candidatePath = path.normalize(path.join(normalizedRoot, childName));
    if (!path.isWithin(normalizedRoot, candidatePath)) {
      throw StateError('Directory locale non valida.');
    }
    final candidate = Directory(candidatePath);
    if (await candidate.exists()) await candidate.delete(recursive: true);
  }
}
