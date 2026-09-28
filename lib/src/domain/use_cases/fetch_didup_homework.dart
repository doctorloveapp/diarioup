import '../homework/homework.dart';
import '../repositories/didup_repository.dart';

final class FetchDidupHomework {
  const FetchDidupHomework(this._repository);

  final DidupRepository _repository;

  Future<HomeworkBatch> call({
    required String profileId,
    required DateTime since,
  }) => _repository.fetchHomework(profileId: profileId, since: since);
}
