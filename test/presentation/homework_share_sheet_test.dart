import 'package:diarioup/src/domain/sharing/homework_export_selection.dart';
import 'package:diarioup/src/domain/homework/school_date.dart';
import 'package:diarioup/src/domain/agenda/subject_agenda.dart';
import 'package:diarioup/src/presentation/l10n/app_copy.dart';
import 'package:diarioup/src/presentation/widgets/homework_share_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('il comando di creazione PDF resta visibile su schermi piccoli', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    HomeworkExportSelection? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () async {
                result = await showHomeworkShareSheet(
                  context,
                  subjects: const [],
                  today: DateTime(2026, 9, 29),
                );
              },
              child: const Text('Apri'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Apri'));
    await tester.pumpAndSettle();
    expect(find.text(AppCopy.sharePdf), findsOneWidget);

    await tester.tap(find.text(AppCopy.sharePdf));
    await tester.pumpAndSettle();
    expect(result?.scope, HomeworkExportScope.week);

    await tester.tap(find.text('Apri'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppCopy.exportWeek));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppCopy.exportNextWeek).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppCopy.sharePdf));
    await tester.pumpAndSettle();
    expect(result?.scope, HomeworkExportScope.nextWeek);
    expect(result?.anchorDate, const SchoolDate(2026, 10, 5));
  });

  testWidgets(
    'selezione multipla, seleziona tutte e conferma restano accessibili',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      HomeworkExportSelection? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  result = await showHomeworkShareSheet(
                    context,
                    subjects: [
                      for (var index = 0; index < 12; index++)
                        SubjectAgenda(
                          id: 'subject-$index',
                          profileId: 'profile-1',
                          name: 'Materia $index',
                          totalHomework: 3,
                          pendingHomework: 2,
                        ),
                    ],
                  );
                },
                child: const Text('Apri'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Apri'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppCopy.exportWeek));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppCopy.exportSubject).last);
      await tester.pumpAndSettle();
      ButtonStyleButton submit() => tester.widget<ButtonStyleButton>(
        find
            .ancestor(
              of: find.text(AppCopy.sharePdf),
              matching: find.byWidgetPredicate(
                (widget) => widget is ButtonStyleButton,
              ),
            )
            .first,
      );
      expect(submit().onPressed, isNull);
      await tester.ensureVisible(find.text(AppCopy.selectAllSubjects));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppCopy.selectAllSubjects));
      await tester.pumpAndSettle();
      expect(submit().onPressed, isNotNull);
      expect(find.text(AppCopy.deselectAllSubjects), findsOneWidget);
      await tester.tap(find.text(AppCopy.deselectAllSubjects));
      await tester.pumpAndSettle();
      expect(submit().onPressed, isNull);
      await tester.ensureVisible(
        find.byKey(const ValueKey('export-subject-subject-0')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('export-subject-subject-0')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const ValueKey('export-subject-subject-11')),
      );
      await tester.tap(find.byKey(const ValueKey('export-subject-subject-11')));
      await tester.pumpAndSettle();
      expect(find.text(AppCopy.sharePdf).hitTestable(), findsOneWidget);
      await tester.tap(find.text(AppCopy.sharePdf));
      await tester.pumpAndSettle();
      expect(result!.subjectsById, {
        'subject-0': 'Materia 0',
        'subject-11': 'Materia 11',
      });
    },
  );
}
