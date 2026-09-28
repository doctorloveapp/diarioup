import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_environment.dart';
import '../../data/auth/didup_auth_service.dart';
import '../../data/auth/flutter_secure_session_store.dart';
import '../../data/client/didup_client.dart';
import '../../data/database/app_database.dart';
import '../../data/database/database_key_store.dart';
import '../../data/database/drift_homework_identity_registry.dart';
import '../../data/database/encrypted_database_factory.dart';
import '../../data/demo/demo_didup_repository.dart';
import '../../data/demo/unavailable_didup_repository.dart';
import '../../data/network/didup_network_client.dart';
import '../../data/normalization/homework_normalizer.dart';
import '../../data/protocol/didup_protocol_config.dart';
import '../../data/repositories/didup_repository_impl.dart';
import '../../domain/repositories/didup_repository.dart';
import '../../domain/agenda/homework_agenda_item.dart';
import '../../domain/agenda/subject_agenda.dart';
import '../../domain/sync/didup_sync.dart';
import '../../domain/use_cases/authenticate_with_didup.dart';

final appEnvironmentProvider = Provider<AppEnvironment>(
  (Ref ref) => AppEnvironment.fromDartDefines(),
);

final appDatabaseProvider = FutureProvider<AppDatabase>((Ref ref) async {
  final database = await EncryptedDatabaseFactory(
    keyStore: FlutterSecureDatabaseKeyStore(),
  ).open();
  ref.onDispose(database.close);
  return database;
});

final didupRepositoryProvider = FutureProvider<DidupRepository>((
  Ref ref,
) async {
  final environment = ref.watch(appEnvironmentProvider);
  final database = await ref.watch(appDatabaseProvider.future);
  final normalizer = HomeworkNormalizer(
    identityRegistry: DriftHomeworkIdentityRegistry(database: database),
  );
  if (environment.isDemo) {
    return DemoDidupRepository(database: database, normalizer: normalizer);
  }
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
    database: database,
    sessionStore: sessionStore,
    normalizer: normalizer,
    adapterVersion: environment.didupClientVersion,
  );
});

final authenticateWithDidupProvider = FutureProvider<AuthenticateWithDidup>(
  (Ref ref) async =>
      AuthenticateWithDidup(await ref.watch(didupRepositoryProvider.future)),
);

final homeworkAgendaProvider =
    StreamProvider.family<List<HomeworkAgendaItem>, String>((
      Ref ref,
      profileId,
    ) async* {
      final repository = await ref.watch(didupRepositoryProvider.future);
      yield* repository.watchHomework(profileId: profileId);
    });

typedef HomeworkDetailRequest = ({String profileId, String homeworkId});

final homeworkDetailProvider =
    StreamProvider.family<HomeworkAgendaItem?, HomeworkDetailRequest>((
      Ref ref,
      request,
    ) async* {
      final repository = await ref.watch(didupRepositoryProvider.future);
      yield* repository.watchHomeworkDetail(
        profileId: request.profileId,
        homeworkId: request.homeworkId,
      );
    });

final subjectsAgendaProvider =
    StreamProvider.family<List<SubjectAgenda>, String>((
      Ref ref,
      profileId,
    ) async* {
      final repository = await ref.watch(didupRepositoryProvider.future);
      yield* repository.watchSubjects(profileId: profileId);
    });

final syncStatusProvider = StreamProvider.family<DidupSyncStatus?, String>((
  Ref ref,
  profileId,
) async* {
  final repository = await ref.watch(didupRepositoryProvider.future);
  yield* repository.watchSyncStatus(profileId: profileId);
});

final syncProfileProvider = FutureProvider.family<DidupSyncResult, String>((
  Ref ref,
  profileId,
) async {
  final repository = await ref.watch(didupRepositoryProvider.future);
  return repository.sync(profileId: profileId);
});
