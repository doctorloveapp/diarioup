import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class DatabaseKeyStore {
  Future<String> loadOrCreate();

  Future<void> clear();
}

final class FlutterSecureDatabaseKeyStore implements DatabaseKeyStore {
  FlutterSecureDatabaseKeyStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const String _storageKey = 'diarioup.database.key.v1';
  final FlutterSecureStorage _storage;

  @override
  Future<String> loadOrCreate() async {
    final stored = await _storage.read(key: _storageKey);
    if (stored != null && stored.isNotEmpty) return stored;

    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    final generated = base64UrlEncode(bytes);
    await _storage.write(key: _storageKey, value: generated);
    return generated;
  }

  @override
  Future<void> clear() => _storage.delete(key: _storageKey);
}
