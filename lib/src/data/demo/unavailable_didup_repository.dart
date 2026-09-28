import '../../domain/auth/auth_credentials.dart';
import '../../domain/auth/auth_result.dart';
import '../../domain/agenda/homework_agenda_item.dart';
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
  Stream<DidupSyncStatus?> watchSyncStatus({required String profileId}) =>
      Stream<DidupSyncStatus?>.error(_configurationRequired());

  @override
  Future<void> setHomeworkCompleted({
    required String profileId,
    required String homeworkId,
    required bool isDone,
  }) async => _configurationRequired();

  @override
  Future<void> logout() async {}
}
