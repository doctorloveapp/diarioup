import 'dart:io';

import 'package:diarioup/diarioup.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

void main() {
  test('inizializza l’orario 1B e persiste materia e colore', () async {
    final directory = await Directory.systemTemp.createTemp(
      'diarioup-timetable-',
    );
    final databaseFile = File(path.join(directory.path, 'timetable.sqlite'));
    var database = AppDatabase(NativeDatabase(databaseFile));
    addTearDown(() async {
      await database.close();
      if (await directory.exists()) await directory.delete(recursive: true);
    });
    await database.storeProfiles(const <StudentProfile>[
      StudentProfile(
        sourceProfileId: 'profile-1',
        displayLabel: 'Profilo test',
        schoolMinistryCode: 'TEST0001',
        academicYear: '2026/2027',
      ),
    ]);
    var repository = LocalTimetableRepository(database: database);

    final seeded = await repository.watch('profile-1').first;
    expect(seeded, hasLength(27));
    final tsolakis = seeded.singleWhere(
      (entry) => entry.weekday == SchoolWeekday.monday && entry.period == 2,
    );
    expect(tsolakis.professorName, 'Prof. Tsolakis');
    expect(tsolakis.subjectName, isNull);

    await repository.updateCell(
      profileId: 'profile-1',
      entryId: tsolakis.id,
      subjectName: 'Matematica',
      subjectColorValue: 0xFF4F46E5,
    );
    await database.close();

    database = AppDatabase(NativeDatabase(databaseFile));
    repository = LocalTimetableRepository(database: database);
    final restored = await repository.watch('profile-1').first;
    final configured = restored.singleWhere((entry) => entry.id == tsolakis.id);
    expect(configured.subjectName, 'Matematica');
    expect(configured.subjectColorValue, 0xFF4F46E5);
  });
}
