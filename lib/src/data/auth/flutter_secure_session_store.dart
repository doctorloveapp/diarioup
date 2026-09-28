import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'session.dart';
import 'session_codec.dart';
import 'session_store.dart';

final class FlutterSecureSessionStore implements SessionStore {
  FlutterSecureSessionStore({
    FlutterSecureStorage? storage,
    SessionCodec codec = const SessionCodec(),
  }) : _storage =
           storage ??
           const FlutterSecureStorage(
             aOptions: AndroidOptions(migrateWithBackup: true),
             iOptions: IOSOptions(
               accessibility: KeychainAccessibility.unlocked_this_device,
             ),
           ),
       _codec = codec;

  static const _key = 'diarioup.didup.session.v1';

  final FlutterSecureStorage _storage;
  final SessionCodec _codec;

  @override
  Future<DidupSession?> read() async {
    final encoded = await _storage.read(key: _key);
    return encoded == null ? null : _codec.decode(encoded);
  }

  @override
  Future<void> write(DidupSession session) =>
      _storage.write(key: _key, value: _codec.encode(session));

  @override
  Future<void> clear() => _storage.delete(key: _key);
}
