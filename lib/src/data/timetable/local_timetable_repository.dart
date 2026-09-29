import '../../domain/repositories/timetable_repository.dart';
import '../../domain/timetable/timetable_entry.dart';
import '../database/app_database.dart';

final class LocalTimetableRepository implements TimetableRepository {
  const LocalTimetableRepository({required AppDatabase database})
    : _database = database;

  final AppDatabase _database;

  @override
  Stream<List<TimetableEntry>> watch(String profileId) async* {
    await _database.seedTimetableIfEmpty(
      profileId,
      _class1BSchedule(profileId),
    );
    yield* _database.watchTimetable(profileId);
  }

  @override
  Future<void> updateCell({
    required String profileId,
    required String entryId,
    required String subjectName,
    required int subjectColorValue,
  }) => _database.updateTimetableCell(
    sourceProfileId: profileId,
    entryId: entryId,
    subjectName: subjectName,
    subjectColorValue: subjectColorValue,
  );
}

List<TimetableEntry> _class1BSchedule(String profileId) {
  const professors = <SchoolWeekday, List<String>>{
    SchoolWeekday.monday: <String>[
      'Prof. Castelli',
      'Prof. Tsolakis',
      'Prof. Tsolakis',
      'Prof. Locanto',
      'Prof. Nicolosi',
      'Prof. Nicolosi',
    ],
    SchoolWeekday.tuesday: <String>[
      'Prof. Locanto',
      'Prof. Tsolakis',
      "Prof. D'Angelo",
      'Prof. Nicolosi',
      'Prof. Castelli',
    ],
    SchoolWeekday.wednesday: <String>[
      'Prof. Farruggia',
      'Prof. Tsolakis',
      'Prof. Nicolosi',
      'Prof. Nicolosi',
      'Prof. Tsolakis',
    ],
    SchoolWeekday.thursday: <String>[
      'Prof. Machì',
      'Prof. Tsolakis',
      'Prof. Tsolakis',
      'Prof. Farruggia',
      'Prof. Nicolosi',
    ],
    SchoolWeekday.friday: <String>[
      'Prof. Locanto',
      "Prof. D'Angelo",
      'Prof. Tsolakis',
      'Prof. Tsolakis',
      'Prof. Castelli',
      'Prof. Nicolosi',
    ],
  };
  final seededAt = DateTime.utc(2026, 9, 29);
  return <TimetableEntry>[
    for (final day in SchoolWeekday.values)
      for (final (index, professor) in professors[day]!.indexed)
        TimetableEntry(
          id: 'class-1b-${day.isoValue}-${index + 1}',
          profileId: profileId,
          weekday: day,
          period: index + 1,
          professorName: professor,
          updatedAt: seededAt,
        ),
  ];
}
