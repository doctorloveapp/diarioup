import 'package:diarioup/src/app/diarioup_app.dart';
import 'package:diarioup/src/data/database/app_database.dart' show AppDatabase;
import 'package:diarioup/src/presentation/l10n/app_copy.dart';
import 'package:diarioup/src/presentation/providers/app_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('onboarding, login e dashboard sono navigabili', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWith((ref) async => database)],
        child: const DiarioUpApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppCopy.onboardingTitle), findsOneWidget);
    await tester.ensureVisible(find.text(AppCopy.start));
    await tester.tap(find.text(AppCopy.start));
    await tester.pumpAndSettle();

    expect(find.text(AppCopy.loginTitle), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, AppCopy.schoolCode),
      'DEMO',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, AppCopy.username),
      'utente-demo',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, AppCopy.password),
      'valore-temporaneo',
    );
    await tester.ensureVisible(find.text(AppCopy.login));
    await tester.tap(find.text(AppCopy.login));
    await tester.pumpAndSettle();

    expect(find.textContaining(AppCopy.dashboardGreeting), findsOneWidget);
    expect(find.text(AppCopy.agenda), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
