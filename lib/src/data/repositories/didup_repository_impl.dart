import '../../domain/auth/auth_credentials.dart';
import '../../domain/auth/auth_result.dart';
import '../../domain/auth/student_profile.dart';
import '../../domain/agenda/homework_agenda_item.dart';
import '../../domain/agenda/manual_homework_input.dart';
import '../../domain/agenda/subject_agenda.dart';
import '../../domain/homework/homework.dart';
import '../../domain/diagnostics/diagnostic_event.dart';
import '../../domain/errors/didup_failure.dart';
import '../../domain/repositories/didup_repository.dart';
import '../../domain/sync/didup_sync.dart';
import '../auth/didup_auth_service.dart';
import '../auth/session.dart';
import '../auth/session_store.dart';
import '../client/didup_client.dart';
import '../database/app_database.dart' hide StudentProfile;
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
    Future<void> Function(String profileId)? onHomeworkChanged,
  }) : _authService = authService,
       _client = client,
       _database = database,
       _sessionStore = sessionStore,
       _normalizer = normalizer,
       _adapterVersion = adapterVersion,
       _dashboardSource =
           dashboardSource ?? NetworkDidupDashboardSource(client),
       _now = now ?? DateTime.now,
       _onHomeworkChanged = onHomeworkChanged;

  final DidupAuthService _authService;
  final DidupClient _client;
  final AppDatabase _database;
  final SessionStore _sessionStore;
  final HomeworkNormalizer _normalizer;
  final DidupDashboardSource _dashboardSource;
  final String _adapterVersion;
  final DateTime Function() _now;
  final Future<void> Function(String profileId)? _onHomeworkChanged;

  @override
  Future<AuthResult> login(AuthCredentials credentials) async {
    final result = await _authService.login(credentials);
    final session = result.profiles.length == 1
        ? result.session.copyWith(
            activeProfileId: result.profiles.single.sourceProfileId,
          )
        : result.session;
    await _sessionStore.write(session);
    try {
      await _database.storeProfiles(result.profiles);
    } catch (_) {
      await _sessionStore.clear();
      rethrow;
    }
    return AuthResult(profiles: result.profiles);
  }

  @override
  Future<StudentProfile?> restoreActiveProfile() async {
    DidupSession? session;
    try {
      session = await _sessionStore.read();
    } on InvalidPayloadFailure {
      await _sessionStore.clear();
      return null;
    }
    if (session == null || session.profiles.isEmpty) return null;

    final storedProfile = session.activeProfileId == null
        ? null
        : session.profiles[session.activeProfileId];
    final profile = storedProfile ?? session.profiles.values.first;
    if (session.activeProfileId != profile.sourceProfileId) {
      await _sessionStore.write(
        session.copyWith(activeProfileId: profile.sourceProfileId),
      );
    }
    return _toStudentProfile(profile);
  }

  @override
  Future<void> rememberActiveProfile(String profileId) async {
    final session = await _sessionStore.read();
    if (session == null || !session.profiles.containsKey(profileId)) {
      throw const SessionExpiredFailure();
    }
    if (session.activeProfileId == profileId) return;
    await _sessionStore.write(session.copyWith(activeProfileId: profileId));
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
      await _refreshReminders(profileId);
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
      await _database.recordDiagnosticEvent(
        area: DiagnosticArea.synchronization,
        code: DiagnosticCode.synchronizationFailed,
        occurredAt: attemptedAt,
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
  }) async {
    await _database.setCompleted(
      sourceProfileId: profileId,
      homeworkId: homeworkId,
      isDone: isDone,
    );
    await _refreshReminders(profileId);
  }

  @override
  Future<void> updateHomeworkNote({
    required String profileId,
    required String homeworkId,
    required String? note,
  }) async {
    await _database.updatePersonalNote(
      sourceProfileId: profileId,
      homeworkId: homeworkId,
      note: note,
    );
    await _refreshReminders(profileId);
  }

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
  Future<String> createManualHomework(ManualHomeworkInput input) async {
    final id = await _database.createManualHomework(input);
    await _refreshReminders(input.profileId);
    return id;
  }

  Future<void> _refreshReminders(String profileId) async {
    try {
      await _onHomeworkChanged?.call(profileId);
    } on Object {
      // Il diario consolidato resta valido se il sistema operativo rifiuta
      // temporaneamente una ripianificazione locale.
    }
  }

  @override
  Future<void> logout() => _client.logout();

  StudentProfile _toStudentProfile(DidupProfileSession profile) =>
      StudentProfile(
        sourceProfileId: profile.sourceProfileId,
        displayLabel: profile.displayLabel,
        gender: profile.gender,
        schoolMinistryCode: profile.schoolMinistryCode,
        academicYear: profile.academicYear,
        academicYearStart: profile.academicYearStart,
      );
}

DateTime _academicYearStart(DateTime now) {
  final year = now.month >= DateTime.september ? now.year : now.year - 1;
  return DateTime.utc(year, DateTime.september);
}
