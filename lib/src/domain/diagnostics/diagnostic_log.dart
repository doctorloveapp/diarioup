import 'diagnostic_event.dart';

abstract interface class DiagnosticLog {
  Stream<List<DiagnosticEvent>> watchRecent();

  Future<void> record(DiagnosticArea area, DiagnosticCode code);
}
