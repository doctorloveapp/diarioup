import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/homework/homework.dart';
import '../normalization/homework_identity_registry.dart';
import 'app_database.dart';

final class DriftHomeworkIdentityRegistry implements HomeworkIdentityRegistry {
  DriftHomeworkIdentityRegistry({required AppDatabase database, Uuid? uuid})
    : _database = database,
      _uuid = uuid ?? const Uuid();

  final AppDatabase _database;
  final Uuid _uuid;

  @override
  Future<HomeworkIdentityResolution> resolve({
    required String profileId,
    required String sourceRecordId,
    required int position,
    required String contentRevision,
    String? sourceItemId,
  }) async {
    final hasSourceIdentifier = sourceItemId != null && sourceItemId.isNotEmpty;
    final nestedIdentity = hasSourceIdentifier
        ? sourceItemId
        : '$sourceRecordId:$position';
    final previous =
        await (_database.select(_database.homeworkIdentityMappings)..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.sourceRecordId.equals(sourceRecordId) &
                  table.nestedIdentity.equals(nestedIdentity),
            ))
            .getSingleOrNull();
    final homeworkId = previous?.homeworkId ?? _uuid.v4();
    await _database
        .into(_database.homeworkIdentityMappings)
        .insertOnConflictUpdate(
          HomeworkIdentityMappingsCompanion.insert(
            profileId: profileId,
            sourceRecordId: sourceRecordId,
            nestedIdentity: nestedIdentity,
            homeworkId: homeworkId,
            contentRevision: contentRevision,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
    return HomeworkIdentityResolution(
      id: homeworkId,
      nestedIdentity: nestedIdentity,
      confidence: hasSourceIdentifier
          ? HomeworkIdentityConfidence.sourceIdentifier
          : HomeworkIdentityConfidence.persistentParentMapping,
      requiresReview:
          !hasSourceIdentifier &&
          previous != null &&
          previous.contentRevision != contentRevision,
    );
  }
}
