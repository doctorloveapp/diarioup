import 'dart:io';

import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'app_database.dart';
import 'database_key_store.dart';

final class EncryptedDatabaseFactory {
  const EncryptedDatabaseFactory({
    required DatabaseKeyStore keyStore,
    this.databaseName = 'diarioup.sqlite',
  }) : _keyStore = keyStore;

  final DatabaseKeyStore _keyStore;
  final String databaseName;

  Future<AppDatabase> open() async {
    final key = await _keyStore.loadOrCreate();
    final file = await databaseFile();
    return AppDatabase(
      NativeDatabase.createInBackground(
        file,
        setup: (sqlite.Database database) =>
            configureEncryptedDatabase(database, key: key),
      ),
    );
  }

  Future<File> databaseFile() async {
    final directory = await getApplicationSupportDirectory();
    return File(path.join(directory.path, databaseName));
  }

  Future<void> deleteDatabaseFiles() async {
    final file = await databaseFile();
    for (final suffix in const <String>['', '-wal', '-shm']) {
      final candidate = File('${file.path}$suffix');
      if (await candidate.exists()) await candidate.delete();
    }
  }
}

void configureEncryptedDatabase(
  sqlite.Database database, {
  required String key,
}) {
  final cipher = database.select('pragma cipher');
  if (cipher.isEmpty) {
    throw StateError('Il runtime SQLite non supporta la cifratura richiesta.');
  }
  final escapedKey = key.replaceAll("'", "''");
  database.execute("pragma key = '$escapedKey'");
  database.select('select count(*) from sqlite_master');
  database.execute('pragma foreign_keys = on');
  database.execute('pragma secure_delete = on');
}
