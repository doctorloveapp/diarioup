import 'session.dart';

abstract interface class SessionStore {
  Future<DidupSession?> read();

  Future<void> write(DidupSession session);

  Future<void> clear();
}
