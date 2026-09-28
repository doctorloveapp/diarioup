import '../../domain/auth/auth_credentials.dart';
import '../../domain/auth/auth_result.dart';
import '../../domain/auth/student_profile.dart';
import '../../domain/homework/homework.dart';
import '../../domain/repositories/didup_repository.dart';

/// Datasource sintetico per la UX: non apre connessioni e non conserva input.
final class DemoDidupRepository implements DidupRepository {
  const DemoDidupRepository();

  @override
  Future<AuthResult> login(AuthCredentials credentials) async {
    return const AuthResult(
      profiles: <StudentProfile>[
        StudentProfile(
          sourceProfileId: 'demo-profile',
          displayLabel: 'Profilo demo',
          schoolMinistryCode: 'DEMO',
          academicYear: '2026/2027',
        ),
      ],
    );
  }

  @override
  Future<HomeworkBatch> fetchHomework({
    required String profileId,
    required DateTime since,
  }) async {
    return const HomeworkBatch(
      homework: <Homework>[],
      deletedSourceRecordIds: <String>[],
      directive: SyncDirective.incremental,
      isPartial: false,
    );
  }

  @override
  Future<void> logout() async {}
}
