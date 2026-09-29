import 'package:diarioup/src/domain/profile/profile_customization.dart';
import 'package:diarioup/src/domain/reminders/reminder_preferences.dart';
import 'package:diarioup/src/presentation/l10n/app_copy.dart';
import 'package:diarioup/src/presentation/pages/settings_page.dart';
import 'package:diarioup/src/presentation/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'le impostazioni restano visibili se il provider permessi fallisce',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      const profileId = 'profile-1';

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileCustomizationProvider(
              profileId,
            ).overrideWith((ref) => Stream.value(const ProfileCustomization())),
            reminderPreferencesProvider(
              profileId,
            ).overrideWith((ref) => Stream.value(const ReminderPreferences())),
            reminderPermissionProvider.overrideWith(
              (ref) async => throw StateError('permesso non disponibile'),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SettingsPage(
                profileId: profileId,
                onSignOut: () async {},
                onCreateHomework: () async {},
                onCreateSubject: () async {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppCopy.settings), findsOneWidget);
      expect(find.text(AppCopy.personalization), findsOneWidget);
      expect(find.text(AppCopy.themeMode), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
