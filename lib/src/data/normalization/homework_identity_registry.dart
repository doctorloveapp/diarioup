import 'package:uuid/uuid.dart';

import '../../domain/homework/homework.dart';

final class HomeworkIdentityResolution {
  const HomeworkIdentityResolution({
    required this.id,
    required this.nestedIdentity,
    required this.confidence,
    required this.requiresReview,
  });

  final String id;
  final String nestedIdentity;
  final HomeworkIdentityConfidence confidence;
  final bool requiresReview;
}

abstract interface class HomeworkIdentityRegistry {
  Future<HomeworkIdentityResolution> resolve({
    required String profileId,
    required String sourceRecordId,
    required int position,
    required String contentRevision,
    String? sourceItemId,
  });
}

/// Registro volatile per prototipo e test. La Fase 1.2 deve sostituirlo con una
/// mappa persistente nel database cifrato, mantenendo lo stesso contratto.
final class InMemoryHomeworkIdentityRegistry
    implements HomeworkIdentityRegistry {
  InMemoryHomeworkIdentityRegistry({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;
  final Map<String, _StoredIdentity> _identities = <String, _StoredIdentity>{};

  @override
  Future<HomeworkIdentityResolution> resolve({
    required String profileId,
    required String sourceRecordId,
    required int position,
    required String contentRevision,
    String? sourceItemId,
  }) async {
    final hasSourceId = sourceItemId != null && sourceItemId.isNotEmpty;
    final nestedIdentity = hasSourceId
        ? sourceItemId
        : '$sourceRecordId:$position';
    final mapKey = '$profileId|$sourceRecordId|$nestedIdentity';
    final previous = _identities[mapKey];
    final requiresReview =
        !hasSourceId &&
        previous != null &&
        previous.contentRevision != contentRevision;
    final stored = _StoredIdentity(
      id: previous?.id ?? _uuid.v4(),
      contentRevision: contentRevision,
    );
    _identities[mapKey] = stored;
    return HomeworkIdentityResolution(
      id: stored.id,
      nestedIdentity: nestedIdentity,
      confidence: hasSourceId
          ? HomeworkIdentityConfidence.sourceIdentifier
          : HomeworkIdentityConfidence.persistentParentMapping,
      requiresReview: requiresReview,
    );
  }
}

final class _StoredIdentity {
  const _StoredIdentity({required this.id, required this.contentRevision});

  final String id;
  final String contentRevision;
}
