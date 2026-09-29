import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart';

import '../../app/app_environment.dart';
import '../../data/auth/didup_auth_service.dart';
import '../../data/auth/flutter_secure_session_store.dart';
import '../../data/auth/session_store.dart';
import '../../data/client/didup_client.dart';
import '../../data/database/app_database.dart';
import '../../data/database/database_key_store.dart';
import '../../data/database/drift_homework_identity_registry.dart';
import '../../data/database/encrypted_database_factory.dart';
import '../../data/diagnostics/drift_diagnostic_log.dart';
import '../../data/network/didup_network_client.dart';
import '../../data/normalization/homework_normalizer.dart';
import '../../data/protocol/didup_protocol_config.dart';
import '../../data/profile/image_picker_gallery_selector.dart';
import '../../data/profile/local_profile_customization_repository.dart';
import '../../data/portability/json_user_data_exporter.dart';
import '../../data/privacy/local_app_data_eraser.dart';
import '../../data/reminders/local_reminder_service.dart';
import '../../data/reminders/reminder_coordinator.dart';
import '../../data/repositories/didup_repository_impl.dart';
import '../../data/sharing/diarioup_pdf_generator.dart';
import '../../data/sharing/native_homework_file_sharer.dart';
import '../../data/timetable/local_timetable_repository.dart';
import '../../data/updates/github_app_release_repository.dart';
import '../../domain/repositories/didup_repository.dart';
import '../../domain/diagnostics/diagnostic_event.dart';
import '../../domain/diagnostics/diagnostic_log.dart';
import '../../domain/errors/didup_failure.dart';
import '../../domain/agenda/homework_agenda_item.dart';
import '../../domain/agenda/subject_agenda.dart';
import '../../domain/reminders/reminder_preferences.dart';
import '../../domain/reminders/reminder_service.dart';
import '../../domain/profile/gallery_image_selector.dart';
import '../../domain/profile/profile_customization.dart';
import '../../domain/portability/user_data_exporter.dart';
import '../../domain/privacy/app_data_eraser.dart';
import '../../domain/repositories/profile_customization_repository.dart';
import '../../domain/repositories/app_release_repository.dart';
import '../../domain/repositories/timetable_repository.dart';
import '../../domain/sharing/homework_file_sharer.dart';
import '../../domain/sharing/homework_pdf_generator.dart';
import '../../domain/sync/didup_sync.dart';
import '../../domain/use_cases/authenticate_with_didup.dart';
import '../../domain/use_cases/share_homework.dart';
import '../../domain/use_cases/check_for_app_update.dart';
import '../../domain/timetable/timetable_entry.dart';

final appEnvironmentProvider = Provider<AppEnvironment>(
  (Ref ref) => AppEnvironment.fromDartDefines(),
);

final databaseKeyStoreProvider = Provider<DatabaseKeyStore>(
  (Ref ref) => FlutterSecureDatabaseKeyStore(),
);

final encryptedDatabaseFactoryProvider = Provider<EncryptedDatabaseFactory>(
  (Ref ref) =>
      EncryptedDatabaseFactory(keyStore: ref.watch(databaseKeyStoreProvider)),
);

final appDatabaseProvider = FutureProvider<AppDatabase>((Ref ref) async {
  final database = await ref.watch(encryptedDatabaseFactoryProvider).open();
  ref.onDispose(database.close);
  return database;
});

final sessionStoreProvider = Provider<SessionStore>(
  (Ref ref) => FlutterSecureSessionStore(),
);

final appVersionProvider = FutureProvider<String>((Ref ref) async {
  final info = await PackageInfo.fromPlatform();
  return '${info.version}+${info.buildNumber}';
});

final appReleaseRepositoryProvider = Provider<AppReleaseRepository>((Ref ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      sendTimeout: const Duration(seconds: 8),
      headers: const <String, String>{'User-Agent': 'DiarioUp'},
    ),
  );
  ref.onDispose(dio.close);
  return GitHubAppReleaseRepository(dio: dio);
});

final checkForAppUpdateProvider = Provider<CheckForAppUpdate>(
  (Ref ref) => CheckForAppUpdate(ref.watch(appReleaseRepositoryProvider)),
);

final galleryImageSelectorProvider = Provider<GalleryImageSelector>(
  (Ref ref) => ImagePickerGallerySelector(),
);

final profileCustomizationRepositoryProvider =
    FutureProvider<ProfileCustomizationRepository>((Ref ref) async {
      return LocalProfileCustomizationRepository(
        database: await ref.watch(appDatabaseProvider.future),
      );
    });

final profileCustomizationProvider =
    StreamProvider.family<ProfileCustomization, String>((
      Ref ref,
      profileId,
    ) async* {
      final repository = await ref.watch(
        profileCustomizationRepositoryProvider.future,
      );
      yield* repository.watch(profileId);
    });

final customizationImageProvider = FutureProvider.autoDispose
    .family<Uint8List?, String>((Ref ref, relativePath) async {
      final repository = await ref.watch(
        profileCustomizationRepositoryProvider.future,
      );
      return repository.loadImage(relativePath);
    });

final timetableRepositoryProvider = FutureProvider<TimetableRepository>((
  Ref ref,
) async {
  return LocalTimetableRepository(
    database: await ref.watch(appDatabaseProvider.future),
  );
});

final timetableProvider = StreamProvider.family<List<TimetableEntry>, String>((
  Ref ref,
  profileId,
) async* {
  final repository = await ref.watch(timetableRepositoryProvider.future);
  yield* repository.watch(profileId);
});

final reminderServiceProvider = Provider<ReminderService>(
  (Ref ref) => LocalReminderService(),
);

final reminderCoordinatorProvider = FutureProvider<ReminderCoordinator>((
  Ref ref,
) async {
  return ReminderCoordinator(
    database: await ref.watch(appDatabaseProvider.future),
    service: ref.watch(reminderServiceProvider),
  );
});

final didupRepositoryProvider = FutureProvider<DidupRepository>((
  Ref ref,
) async {
  final environment = ref.watch(appEnvironmentProvider);
  if (!environment.hasDidupConfiguration) {
    throw const CompatibilityFailure(
      'Configurazione DidUP non disponibile. Installa una release ufficiale.',
    );
  }
  final database = await ref.watch(appDatabaseProvider.future);
  final reminderCoordinator = await ref.watch(
    reminderCoordinatorProvider.future,
  );
  final normalizer = HomeworkNormalizer(
    identityRegistry: DriftHomeworkIdentityRegistry(database: database),
  );
  final config = DidupProtocolConfig(
    oauthClientId: environment.didupOauthClientId,
    redirectUri: Uri.parse(environment.didupRedirectUri),
    clientVersion: environment.didupClientVersion,
  );
  final network = DidupNetworkClient.create(config: config);
  ref.onDispose(network.dio.close);
  final sessionStore = ref.watch(sessionStoreProvider);
  return DidupRepositoryImpl(
    authService: DioDidupAuthService(networkClient: network),
    client: DidupClient(networkClient: network, sessionStore: sessionStore),
    database: database,
    sessionStore: sessionStore,
    normalizer: normalizer,
    adapterVersion: environment.didupClientVersion,
    onHomeworkChanged: reminderCoordinator.reschedule,
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

final reminderPreferencesProvider =
    StreamProvider.family<ReminderPreferences, String>((
      Ref ref,
      profileId,
    ) async* {
      final coordinator = await ref.watch(reminderCoordinatorProvider.future);
      yield* coordinator.watchPreferences(profileId);
    });

final reminderPermissionProvider = FutureProvider<ReminderPermissionStatus>((
  Ref ref,
) async {
  final coordinator = await ref.watch(reminderCoordinatorProvider.future);
  return coordinator.permissionStatus();
});

final reminderBootstrapProvider = FutureProvider.family<void, String>((
  Ref ref,
  profileId,
) async {
  final coordinator = await ref.watch(reminderCoordinatorProvider.future);
  await coordinator.reschedule(profileId);
});

final diagnosticLogProvider = FutureProvider<DiagnosticLog>((Ref ref) async {
  return DriftDiagnosticLog(
    database: await ref.watch(appDatabaseProvider.future),
  );
});

typedef DiagnosticRecord =
    void Function(DiagnosticArea area, DiagnosticCode code);

final diagnosticRecorderProvider = Provider<DiagnosticRecord>((Ref ref) {
  return (area, code) {
    ref
        .read(diagnosticLogProvider.future)
        .then((log) => log.record(area, code))
        .ignore();
  };
});

final recentDiagnosticsProvider = StreamProvider<List<DiagnosticEvent>>((
  Ref ref,
) async* {
  final log = await ref.watch(diagnosticLogProvider.future);
  yield* log.watchRecent();
});

final userDataExporterProvider = FutureProvider<UserDataExporter>((
  Ref ref,
) async {
  return JsonUserDataExporter(
    repository: await ref.watch(didupRepositoryProvider.future),
    appVersion: await ref.watch(appVersionProvider.future),
  );
});

final appDataEraserProvider = FutureProvider<AppDataEraser>((Ref ref) async {
  return LocalAppDataEraser(
    database: await ref.watch(appDatabaseProvider.future),
    deleteDatabaseFiles: ref
        .watch(encryptedDatabaseFactoryProvider)
        .deleteDatabaseFiles,
    databaseKeyStore: ref.watch(databaseKeyStoreProvider),
    sessionStore: ref.watch(sessionStoreProvider),
    reminderService: ref.watch(reminderServiceProvider),
  );
});

final homeworkPdfGeneratorProvider = FutureProvider<HomeworkPdfGenerator>((
  Ref ref,
) async {
  final assets = await Future.wait<ByteData>(<Future<ByteData>>[
    rootBundle.load('assets/logo_diarioup.png'),
    rootBundle.load('assets/fonts/inter/InterVariable.ttf'),
  ]);
  Uint8List bytesOf(ByteData data) =>
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  return DiarioUpPdfGenerator(
    logoBytes: bytesOf(assets[0]),
    fontBytes: bytesOf(assets[1]),
  );
});

final homeworkFileSharerProvider = Provider<HomeworkFileSharer>(
  (Ref ref) => NativeHomeworkFileSharer(),
);

final shareHomeworkProvider = FutureProvider<ShareHomework>((Ref ref) async {
  return ShareHomework(
    repository: await ref.watch(didupRepositoryProvider.future),
    pdfGenerator: await ref.watch(homeworkPdfGeneratorProvider.future),
    fileSharer: ref.watch(homeworkFileSharerProvider),
  );
});
