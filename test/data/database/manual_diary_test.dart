import 'package:diarioup/diarioup.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'materia, compito, nota e checklist manuali restano nel database',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await database.storeProfiles(const <StudentProfile>[
        StudentProfile(
          sourceProfileId: 'profile-1',
          displayLabel: 'Profilo test',
          schoolMinistryCode: 'TEST0001',
          academicYear: '2026/2027',
        ),
      ]);

      final subjectId = await database.createManualSubject(
        sourceProfileId: 'profile-1',
        name: 'Matematica',
        colorValue: 0xFF4F46E5,
      );
      final homeworkId = await database.createManualHomework(
        ManualHomeworkInput(
          profileId: 'profile-1',
          subjectId: subjectId,
          text: '  Esercizi 1 e 2  ',
          dueOn: const SchoolDate(2026, 10, 1),
          personalNote: 'Pagina 42',
        ),
      );

      var items = await database
          .watchAgenda('profile-1')
          .firstWhere((value) => value.isNotEmpty);
      expect(items.single.id, homeworkId);
      expect(items.single.text, 'Esercizi 1 e 2');
      expect(items.single.subjectName, 'Matematica');
      expect(items.single.origin, HomeworkOrigin.manual);
      expect(items.single.dueOn, const SchoolDate(2026, 10, 1));
      expect(items.single.personalNote, 'Pagina 42');

      var subjects = await database
          .watchSubjects('profile-1')
          .firstWhere((value) => value.isNotEmpty);
      expect(subjects.single.totalHomework, 1);
      expect(subjects.single.pendingHomework, 1);

      await database.updatePersonalNote(
        sourceProfileId: 'profile-1',
        homeworkId: homeworkId,
        note: '  Usare il compasso  ',
      );
      await database.setCompleted(
        sourceProfileId: 'profile-1',
        homeworkId: homeworkId,
        isDone: true,
      );

      items = await database
          .watchAgenda('profile-1')
          .firstWhere((value) => value.single.isDone);
      subjects = await database
          .watchSubjects('profile-1')
          .firstWhere((value) => value.single.pendingHomework == 0);
      expect(items.single.personalNote, 'Usare il compasso');
      expect(subjects.single.totalHomework, 1);
      expect(subjects.single.pendingHomework, 0);
    },
  );
}
