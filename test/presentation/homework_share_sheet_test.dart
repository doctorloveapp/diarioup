import 'package:diarioup/src/domain/sharing/homework_export_selection.dart';
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
  });
}
