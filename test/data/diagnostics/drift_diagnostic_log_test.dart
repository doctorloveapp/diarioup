import 'package:diarioup/diarioup.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'conserva nel database cifrabile soltanto gli ultimi 10 eventi',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      var now = DateTime.utc(2026, 9, 28, 10);
      final log = DriftDiagnosticLog(database: database, now: () => now);

      for (var index = 0; index < 12; index++) {
        now = now.add(const Duration(minutes: 1));
        await log.record(
          DiagnosticArea.synchronization,
          DiagnosticCode.synchronizationFailed,
        );
      }
      final events = await log.watchRecent().first;

      expect(events, hasLength(10));
      expect(events.first.occurredAt, DateTime.utc(2026, 9, 28, 10, 12));
      expect(events.last.occurredAt, DateTime.utc(2026, 9, 28, 10, 3));
      expect(
        events.every(
          (event) =>
              event.area == DiagnosticArea.synchronization &&
              event.code == DiagnosticCode.synchronizationFailed,
        ),
        isTrue,
      );
    },
  );
}
