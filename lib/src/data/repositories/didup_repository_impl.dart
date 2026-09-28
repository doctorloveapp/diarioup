import '../../domain/auth/auth_credentials.dart';
import '../../domain/auth/auth_result.dart';
import '../../domain/homework/homework.dart';
import '../../domain/repositories/didup_repository.dart';
import '../auth/didup_auth_service.dart';
import '../auth/session_store.dart';
import '../client/didup_client.dart';
import '../normalization/homework_normalizer.dart';

final class DidupRepositoryImpl implements DidupRepository {
  const DidupRepositoryImpl({
    required DidupAuthService authService,
    required DidupClient client,
    required SessionStore sessionStore,
    required HomeworkNormalizer normalizer,
  }) : _authService = authService,
       _client = client,
       _sessionStore = sessionStore,
       _normalizer = normalizer;

  final DidupAuthService _authService;
  final DidupClient _client;
  final SessionStore _sessionStore;
  final HomeworkNormalizer _normalizer;

  @override
  Future<AuthResult> login(AuthCredentials credentials) async {
    final result = await _authService.login(credentials);
    await _sessionStore.write(result.session);
    return AuthResult(profiles: result.profiles);
  }

  @override
  Future<HomeworkBatch> fetchHomework({
    required String profileId,
    required DateTime since,
  }) async {
    final response = await _client.fetchDashboard(
      profileId: profileId,
      since: since,
    );
    return _normalizer.normalizeDashboard(
      profileId: profileId,
      response: response,
    );
  }

  @override
  Future<void> logout() => _client.logout();
}
