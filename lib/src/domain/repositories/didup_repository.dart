import '../auth/auth_credentials.dart';
import '../auth/auth_result.dart';
import '../homework/homework.dart';

abstract interface class DidupRepository {
  Future<AuthResult> login(AuthCredentials credentials);

  Future<HomeworkBatch> fetchHomework({
    required String profileId,
    required DateTime since,
  });

  Future<void> logout();
}
