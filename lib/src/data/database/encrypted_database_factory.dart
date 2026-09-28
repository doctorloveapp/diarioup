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
    final directory = await getApplicationSupportDirectory();
    final file = File(path.join(directory.path, databaseName));
    return AppDatabase(
      NativeDatabase.createInBackground(
        file,
        setup: (sqlite.Database database) =>
            configureEncryptedDatabase(database, key: key),
      ),
    );
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
