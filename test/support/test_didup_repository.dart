import 'package:diarioup/diarioup.dart';

/// Repository deterministico disponibile soltanto nella suite di test.
///
/// Il file vive sotto `test/` e non viene compilato negli artefatti dell'app.
final class TestDidupRepository implements DidupRepository {
  TestDidupRepository({required AppDatabase database})
    : _database = database,
      _normalizer = HomeworkNormalizer(
        identityRegistry: DriftHomeworkIdentityRegistry(database: database),
      );

  final AppDatabase _database;
  final HomeworkNormalizer _normalizer;
  StudentProfile? _activeProfile;

  static const _profile = StudentProfile(
    sourceProfileId: 'test-profile',
    displayLabel: 'Profilo sintetico',
    schoolMinistryCode: 'TEST0000',
    academicYear: '2026/2027',
  );

  @override
  Future<AuthResult> login(AuthCredentials credentials) async {
    await _database.storeProfiles(const <StudentProfile>[_profile]);
    return const AuthResult(profiles: <StudentProfile>[_profile]);
  }

  @override
  Future<StudentProfile?> restoreActiveProfile() async => _activeProfile;

  @override
  Future<void> rememberActiveProfile(String profileId) async {
    if (profileId != _profile.sourceProfileId) {
      throw StateError('Profilo di test sconosciuto.');
    }
    _activeProfile = _profile;
  }

  @override
  Future<HomeworkBatch> fetchHomework({
    required String profileId,
    required DateTime since,
  }) async {
    await _database.storeProfiles(const <StudentProfile>[_profile]);
    final internalId = await _database.internalProfileId(profileId);
    return _database.transaction(
      () => _normalizer.normalizeDashboard(
        profileId: internalId,
        response: _dashboardFixture(),
      ),
    );
  }

  @override
  Future<DidupSyncResult> sync({required String profileId}) async {
    await _database.storeProfiles(const <StudentProfile>[_profile]);
    final internalId = await _database.internalProfileId(profileId);
    final completedAt = DateTime.now().toUtc();
    late HomeworkBatch batch;
    await _database.transaction(() async {
      batch = await _normalizer.normalizeDashboard(
        profileId: internalId,
        response: _dashboardFixture(),
      );
      await _database.saveSyncBatch(
        internalProfileId: internalId,
        batch: batch,
        attemptedAt: completedAt,
        coverageStart: DateTime.utc(2026, DateTime.september),
        adapterVersion: 'test-adapter',
      );
    });
    return DidupSyncResult(
      savedHomeworkCount: batch.homework.length,
      completedAt: completedAt,
      wasPartial: batch.isPartial,
    );
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
  Future<void> logout() async {}
}

Map<String, Object?> _dashboardFixture() => <String, Object?>{
  'success': true,
  'data': <String, Object?>{
    'dati': <Object?>[
      <String, Object?>{
        'registro': <Object?>[
          <String, Object?>{
            'pk': 'test-record-1',
            'datGiorno': '28/09/2026',
            'materia': 'Italiano',
            'pkMateria': 'test-subject-1',
            'compiti': <Object?>[
              <String, Object?>{
                'pk': 'test-homework-1',
                'compito': 'Leggere il capitolo assegnato',
                'dataConsegna': '29/09/2026',
              },
            ],
          },
          <String, Object?>{
            'pk': 'test-record-2',
            'datGiorno': '28/09/2026',
            'materia': 'Matematica',
            'pkMateria': 'test-subject-2',
            'compiti': <Object?>[
              <String, Object?>{
                'pk': 'test-homework-2',
                'compito': 'Esercizi 12–18',
                'dataConsegna': '30/09/2026',
              },
            ],
          },
        ],
      },
    ],
  },
};
