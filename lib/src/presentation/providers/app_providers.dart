import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_environment.dart';
import '../../data/auth/didup_auth_service.dart';
import '../../data/auth/flutter_secure_session_store.dart';
import '../../data/client/didup_client.dart';
import '../../data/demo/demo_didup_repository.dart';
import '../../data/demo/unavailable_didup_repository.dart';
import '../../data/network/didup_network_client.dart';
import '../../data/normalization/homework_identity_registry.dart';
import '../../data/normalization/homework_normalizer.dart';
import '../../data/protocol/didup_protocol_config.dart';
import '../../data/repositories/didup_repository_impl.dart';
import '../../domain/repositories/didup_repository.dart';
import '../../domain/use_cases/authenticate_with_didup.dart';

final appEnvironmentProvider = Provider<AppEnvironment>(
  (Ref ref) => AppEnvironment.fromDartDefines(),
);

final didupRepositoryProvider = Provider<DidupRepository>((Ref ref) {
  final environment = ref.watch(appEnvironmentProvider);
  if (environment.isDemo) return const DemoDidupRepository();
  if (!environment.hasDidupConfiguration) {
    return const UnavailableDidupRepository();
  }

  final config = DidupProtocolConfig(
    oauthClientId: environment.didupOauthClientId,
    redirectUri: Uri.parse(environment.didupRedirectUri),
    clientVersion: environment.didupClientVersion,
  );
  final network = DidupNetworkClient.create(config: config);
  ref.onDispose(network.dio.close);
  final sessionStore = FlutterSecureSessionStore();
  return DidupRepositoryImpl(
    authService: DioDidupAuthService(networkClient: network),
    client: DidupClient(networkClient: network, sessionStore: sessionStore),
    sessionStore: sessionStore,
    normalizer: HomeworkNormalizer(
      identityRegistry: InMemoryHomeworkIdentityRegistry(),
    ),
  );
});

final authenticateWithDidupProvider = Provider<AuthenticateWithDidup>(
  (Ref ref) => AuthenticateWithDidup(ref.watch(didupRepositoryProvider)),
);
