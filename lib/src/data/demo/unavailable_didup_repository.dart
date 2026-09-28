import '../../domain/auth/auth_credentials.dart';
import '../../domain/auth/auth_result.dart';
import '../../domain/agenda/homework_agenda_item.dart';
import '../../domain/agenda/manual_homework_input.dart';
import '../../domain/agenda/subject_agenda.dart';
import '../../domain/errors/didup_failure.dart';
import '../../domain/homework/homework.dart';
import '../../domain/repositories/didup_repository.dart';
import '../../domain/sync/didup_sync.dart';

final class UnavailableDidupRepository implements DidupRepository {
  const UnavailableDidupRepository();

  Never _configurationRequired() => throw const CompatibilityFailure(
    'Configurazione DidUP assente. Avvia la build demo oppure fornisci i '
    'Dart define autorizzati.',
  );

  @override
  Future<AuthResult> login(AuthCredentials credentials) async =>
      _configurationRequired();

  @override
  Future<HomeworkBatch> fetchHomework({
    required String profileId,
    required DateTime since,
  }) async => _configurationRequired();

  @override
  Future<DidupSyncResult> sync({required String profileId}) async =>
      _configurationRequired();

  @override
  Stream<List<HomeworkAgendaItem>> watchHomework({required String profileId}) =>
      Stream<List<HomeworkAgendaItem>>.error(_configurationRequired());

  @override
  Stream<HomeworkAgendaItem?> watchHomeworkDetail({
    required String profileId,
    required String homeworkId,
  }) => Stream<HomeworkAgendaItem?>.error(_configurationRequired());

  @override
  Stream<List<SubjectAgenda>> watchSubjects({required String profileId}) =>
      Stream<List<SubjectAgenda>>.error(_configurationRequired());

  @override
  Stream<DidupSyncStatus?> watchSyncStatus({required String profileId}) =>
      Stream<DidupSyncStatus?>.error(_configurationRequired());

  @override
  Future<void> setHomeworkCompleted({
    required String profileId,
    required String homeworkId,
    required bool isDone,
  }) async => _configurationRequired();

  @override
  Future<void> updateHomeworkNote({
    required String profileId,
    required String homeworkId,
    required String? note,
  }) async => _configurationRequired();

  @override
  Future<String> createManualSubject({
    required String profileId,
    required String name,
    required int colorValue,
  }) async => _configurationRequired();

  @override
  Future<String> createManualHomework(ManualHomeworkInput input) async =>
      _configurationRequired();

  @override
  Future<void> logout() async {}
}
