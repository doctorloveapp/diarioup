import 'package:diarioup/src/domain/homework/school_date.dart';
import 'package:diarioup/src/presentation/formatters/homework_formatters.dart';
import 'package:diarioup/src/presentation/l10n/app_copy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final today = DateTime(2026, 9, 28, 22, 30);

  test('countdown usa giorni di calendario e gestisce oggi e domani', () {
    expect(
      homeworkCountdown(const SchoolDate(2026, 9, 28), now: today),
      AppCopy.dueToday,
    );
    expect(
      homeworkCountdown(const SchoolDate(2026, 9, 29), now: today),
      AppCopy.dueTomorrow,
    );
    expect(
      homeworkCountdown(const SchoolDate(2026, 9, 30), now: today),
      'Tra 2 giorni',
    );
  });

  test('countdown distingue scaduti e data assente', () {
    expect(
      homeworkCountdown(const SchoolDate(2026, 9, 27), now: today),
      AppCopy.overdueYesterday,
    );
    expect(
      homeworkCountdown(const SchoolDate(2026, 9, 25), now: today),
      'Scaduto da 3 giorni',
    );
    expect(homeworkCountdown(null, now: today), AppCopy.noDueDate);
  });
}
