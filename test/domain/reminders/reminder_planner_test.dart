import 'package:diarioup/diarioup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 9, 28, 17);

  test('raggruppa per scadenza e pianifica alle 18 del giorno prima', () {
    final plan = ReminderPlanner.build(
      homework: <HomeworkAgendaItem>[
        _homework('a', const SchoolDate(2026, 9, 29)),
        _homework('b', const SchoolDate(2026, 9, 29)),
        _homework('c', const SchoolDate(2026, 9, 30)),
      ],
      preferences: const ReminderPreferences(enabled: true),
      now: now,
    );

    expect(plan, hasLength(2));
    expect(plan.first.remindOn, const SchoolDate(2026, 9, 28));
    expect(plan.first.hour, 18);
    expect(plan.last.remindOn, const SchoolDate(2026, 9, 29));
  });

  test('esclude completati, date assenti, orari passati e oltre 14 giorni', () {
    final plan = ReminderPlanner.build(
      homework: <HomeworkAgendaItem>[
        _homework('done', const SchoolDate(2026, 9, 30), isDone: true),
        _homework('missing', null),
        _homework('tomorrow', const SchoolDate(2026, 9, 29)),
        _homework('far', const SchoolDate(2026, 10, 13)),
      ],
      preferences: const ReminderPreferences(enabled: true),
      now: DateTime(2026, 9, 28, 18, 1),
    );

    expect(plan, isEmpty);
  });

  test('non pianifica quando i promemoria sono disattivati', () {
    final plan = ReminderPlanner.build(
      homework: <HomeworkAgendaItem>[
        _homework('a', const SchoolDate(2026, 9, 30)),
      ],
      preferences: const ReminderPreferences(),
      now: now,
    );

    expect(plan, isEmpty);
  });
}

HomeworkAgendaItem _homework(
  String id,
  SchoolDate? dueOn, {
  bool isDone = false,
}) {
  return HomeworkAgendaItem(
    id: id,
    profileId: 'profile-1',
    text: 'Compito $id',
    dueOn: dueOn,
    isDone: isDone,
    changedAfterCompletion: false,
    requiresIdentityReview: false,
    origin: HomeworkOrigin.manual,
    updatedAt: DateTime.utc(2026, 9, 28),
  );
}
