import '../../domain/diagnostics/diagnostic_event.dart';
import '../../domain/diagnostics/diagnostic_log.dart';
import '../database/app_database.dart';

final class DriftDiagnosticLog implements DiagnosticLog {
  DriftDiagnosticLog({required AppDatabase database, DateTime Function()? now})
    : _database = database,
      _now = now ?? DateTime.now;

  final AppDatabase _database;
  final DateTime Function() _now;

  @override
  Stream<List<DiagnosticEvent>> watchRecent() =>
      _database.watchRecentDiagnosticEvents();

  @override
  Future<void> record(DiagnosticArea area, DiagnosticCode code) => _database
      .recordDiagnosticEvent(area: area, code: code, occurredAt: _now());
}
