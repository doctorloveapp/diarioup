import '../auth/auth_credentials.dart';
import '../auth/auth_result.dart';
import '../repositories/didup_repository.dart';

final class AuthenticateWithDidup {
  const AuthenticateWithDidup(this._repository);

  final DidupRepository _repository;

  Future<AuthResult> call(AuthCredentials credentials) =>
      _repository.login(credentials);
}
