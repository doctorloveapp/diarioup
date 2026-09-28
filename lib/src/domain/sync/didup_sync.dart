final class DidupSyncResult {
  const DidupSyncResult({
    required this.savedHomeworkCount,
    required this.completedAt,
    required this.wasPartial,
  });

  final int savedHomeworkCount;
  final DateTime completedAt;
  final bool wasPartial;
}

final class DidupSyncStatus {
  const DidupSyncStatus({
    required this.profileId,
    this.lastAttemptAt,
    this.lastSuccessAt,
    this.coverageStart,
    this.errorCode,
  });

  final String profileId;
  final DateTime? lastAttemptAt;
  final DateTime? lastSuccessAt;
  final DateTime? coverageStart;
  final String? errorCode;
}
