enum DiagnosticArea {
  authentication,
  synchronization,
  homework,
  personalization,
  reminders,
  sharing,
  portability,
  storage,
}

enum DiagnosticCode {
  authenticationFailed,
  synchronizationFailed,
  completionUpdateFailed,
  manualEntryFailed,
  noteUpdateFailed,
  personalizationFailed,
  reminderUpdateFailed,
  shareFailed,
  exportFailed,
  deletionFailed,
}

final class DiagnosticEvent {
  const DiagnosticEvent({
    required this.occurredAt,
    required this.area,
    required this.code,
  });

  final DateTime occurredAt;
  final DiagnosticArea area;
  final DiagnosticCode code;
}
