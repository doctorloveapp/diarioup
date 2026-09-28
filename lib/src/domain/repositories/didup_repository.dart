import '../auth/auth_credentials.dart';
import '../auth/auth_result.dart';
import '../agenda/homework_agenda_item.dart';
import '../homework/homework.dart';
import '../sync/didup_sync.dart';

abstract interface class DidupRepository {
  Future<AuthResult> login(AuthCredentials credentials);

  Future<HomeworkBatch> fetchHomework({
    required String profileId,
    required DateTime since,
  });

  Future<DidupSyncResult> sync({required String profileId});

  Stream<List<HomeworkAgendaItem>> watchHomework({required String profileId});

  Stream<DidupSyncStatus?> watchSyncStatus({required String profileId});

  Future<void> setHomeworkCompleted({
    required String profileId,
    required String homeworkId,
    required bool isDone,
  });

  Future<void> logout();
}
