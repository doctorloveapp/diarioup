import '../../domain/auth/auth_credentials.dart';
import '../../domain/auth/auth_result.dart';
import '../../domain/agenda/homework_agenda_item.dart';
import '../../domain/agenda/manual_homework_input.dart';
import '../../domain/agenda/subject_agenda.dart';
import '../../domain/homework/homework.dart';
import '../../domain/repositories/didup_repository.dart';
import '../../domain/sync/didup_sync.dart';
import '../auth/didup_auth_service.dart';
import '../auth/session_store.dart';
import '../client/didup_client.dart';
import '../database/app_database.dart';
import '../normalization/homework_normalizer.dart';
import '../sync/didup_dashboard_source.dart';

final class DidupRepositoryImpl implements DidupRepository {
  DidupRepositoryImpl({
    required DidupAuthService authService,
    required DidupClient client,
    required AppDatabase database,
    required SessionStore sessionStore,
    required HomeworkNormalizer normalizer,
    required String adapterVersion,
    DidupDashboardSource? dashboardSource,
    DateTime Function()? now,
  }) : _authService = authService,
       _client = client,
       _database = database,
       _sessionStore = sessionStore,
       _normalizer = normalizer,
       _adapterVersion = adapterVersion,
       _dashboardSource =
           dashboardSource ?? NetworkDidupDashboardSource(client),
       _now = now ?? DateTime.now;

  final DidupAuthService _authService;
  final DidupClient _client;
  final AppDatabase _database;
  final SessionStore _sessionStore;
  final HomeworkNormalizer _normalizer;
  final DidupDashboardSource _dashboardSource;
  final String _adapterVersion;
  final DateTime Function() _now;

  @override
  Future<AuthResult> login(AuthCredentials credentials) async {
    final result = await _authService.login(credentials);
    await _sessionStore.write(result.session);
    try {
      await _database.storeProfiles(result.profiles);
    } catch (_) {
      await _sessionStore.clear();
      rethrow;
    }
    return AuthResult(profiles: result.profiles);
  }

  @override
  Future<HomeworkBatch> fetchHomework({
    required String profileId,
    required DateTime since,
  }) async {
    final internalProfileId = await _database.internalProfileId(profileId);
    final response = await _dashboardSource.download(
      profileId: profileId,
      since: since,
    );
    return _database.transaction(
      () => _normalizer.normalizeDashboard(
        profileId: internalProfileId,
        response: response,
      ),
    );
  }

  @override
  Future<DidupSyncResult> sync({required String profileId}) async {
    final internalProfileId = await _database.internalProfileId(profileId);
    final attemptedAt = _now().toUtc();
    final previousSuccess = await _database.lastSuccessfulSync(
      internalProfileId,
    );
    final coverageStart = previousSuccess ?? _academicYearStart(attemptedAt);
    try {
      final response = await _dashboardSource.download(
        profileId: profileId,
        since: coverageStart,
      );
      late HomeworkBatch batch;
      await _database.transaction(() async {
        batch = await _normalizer.normalizeDashboard(
          profileId: internalProfileId,
          response: response,
        );
        await _database.saveSyncBatch(
          internalProfileId: internalProfileId,
          batch: batch,
          attemptedAt: attemptedAt,
          coverageStart: coverageStart,
          adapterVersion: _adapterVersion,
        );
      });
      return DidupSyncResult(
        savedHomeworkCount: batch.homework.length,
        completedAt: attemptedAt,
        wasPartial: batch.isPartial,
      );
    } catch (_) {
      await _database.recordSyncFailure(
        internalProfileId: internalProfileId,
        attemptedAt: attemptedAt,
        adapterVersion: _adapterVersion,
        errorCode: 'sync_failed',
      );
      rethrow;
    }
  }

  @override
  Stream<List<HomeworkAgendaItem>> watchHomework({required String profileId}) =>
      _database.watchAgenda(profileId);

  @override
  Stream<HomeworkAgendaItem?> watchHomeworkDetail({
    required String profileId,
    required String homeworkId,
  }) => _database.watchHomeworkDetail(
    sourceProfileId: profileId,
    homeworkId: homeworkId,
  );

  @override
  Stream<List<SubjectAgenda>> watchSubjects({required String profileId}) =>
      _database.watchSubjects(profileId);

  @override
  Stream<DidupSyncStatus?> watchSyncStatus({required String profileId}) =>
      _database.watchSyncStatus(profileId);

  @override
  Future<void> setHomeworkCompleted({
    required String profileId,
    required String homeworkId,
    required bool isDone,
  }) => _database.setCompleted(
    sourceProfileId: profileId,
    homeworkId: homeworkId,
    isDone: isDone,
  );

  @override
  Future<void> updateHomeworkNote({
    required String profileId,
    required String homeworkId,
    required String? note,
  }) => _database.updatePersonalNote(
    sourceProfileId: profileId,
    homeworkId: homeworkId,
    note: note,
  );

  @override
  Future<String> createManualSubject({
    required String profileId,
    required String name,
    required int colorValue,
  }) => _database.createManualSubject(
    sourceProfileId: profileId,
    name: name,
    colorValue: colorValue,
  );

  @override
  Future<String> createManualHomework(ManualHomeworkInput input) =>
      _database.createManualHomework(input);

  @override
  Future<void> logout() => _client.logout();
}

DateTime _academicYearStart(DateTime now) {
  final year = now.month >= DateTime.september ? now.year : now.year - 1;
  return DateTime.utc(year, DateTime.september);
}
