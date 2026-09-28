import '../../domain/auth/auth_credentials.dart';
import '../../domain/auth/auth_result.dart';
import '../../domain/auth/student_profile.dart';
import '../../domain/agenda/homework_agenda_item.dart';
import '../../domain/agenda/manual_homework_input.dart';
import '../../domain/agenda/subject_agenda.dart';
import '../../domain/homework/homework.dart';
import '../../domain/repositories/didup_repository.dart';
import '../../domain/sync/didup_sync.dart';
import '../database/app_database.dart' show AppDatabase;
import '../normalization/homework_normalizer.dart';

/// Datasource sintetico per la UX: non apre connessioni e non conserva input.
final class DemoDidupRepository implements DidupRepository {
  const DemoDidupRepository({
    required AppDatabase database,
    required HomeworkNormalizer normalizer,
    Future<void> Function(String profileId)? onHomeworkChanged,
  }) : _database = database,
       _normalizer = normalizer,
       _onHomeworkChanged = onHomeworkChanged;

  final AppDatabase _database;
  final HomeworkNormalizer _normalizer;
  final Future<void> Function(String profileId)? _onHomeworkChanged;

  static const StudentProfile _profile = StudentProfile(
    sourceProfileId: 'demo-profile',
    displayLabel: 'Profilo demo',
    schoolMinistryCode: 'DEMO',
    academicYear: '2026/2027',
  );

  @override
  Future<AuthResult> login(AuthCredentials credentials) async {
    await _database.storeProfiles(const <StudentProfile>[_profile]);
    return const AuthResult(profiles: <StudentProfile>[_profile]);
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
        response: _demoDashboard(),
      ),
    );
  }

  @override
  Future<DidupSyncResult> sync({required String profileId}) async {
    await _database.storeProfiles(const <StudentProfile>[_profile]);
    final internalId = await _database.internalProfileId(profileId);
    final now = DateTime.now().toUtc();
    late HomeworkBatch batch;
    await _database.transaction(() async {
      batch = await _normalizer.normalizeDashboard(
        profileId: internalId,
        response: _demoDashboard(),
      );
      await _database.saveSyncBatch(
        internalProfileId: internalId,
        batch: batch,
        attemptedAt: now,
        coverageStart: DateTime.utc(2026, DateTime.september),
        adapterVersion: 'demo-v1',
      );
    });
    await _refreshReminders(profileId);
    return DidupSyncResult(
      savedHomeworkCount: batch.homework.length,
      completedAt: now,
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
      // Una ripianificazione locale non può rendere fallita l'operazione dati.
    }
  }

  @override
  Future<void> logout() async {}
}

Map<String, Object?> _demoDashboard() => <String, Object?>{
  'success': true,
  'data': <String, Object?>{
    'dati': <Object?>[
      <String, Object?>{
        'registro': <Object?>[
          <String, Object?>{
            'pk': 'demo-record-1',
            'datGiorno': '28/09/2026',
            'materia': 'Italiano',
            'pkMateria': 'demo-subject-1',
            'compiti': <Object?>[
              <String, Object?>{
                'pk': 'demo-homework-1',
                'compito': 'Leggere il capitolo assegnato',
                'dataConsegna': '29/09/2026',
              },
            ],
          },
          <String, Object?>{
            'pk': 'demo-record-2',
            'datGiorno': '28/09/2026',
            'materia': 'Matematica',
            'pkMateria': 'demo-subject-2',
            'compiti': <Object?>[
              <String, Object?>{
                'pk': 'demo-homework-2',
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
