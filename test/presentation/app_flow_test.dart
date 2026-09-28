import 'dart:async';
import 'dart:typed_data';

import 'package:diarioup/src/app/diarioup_app.dart';
import 'package:diarioup/src/data/database/app_database.dart' show AppDatabase;
import 'package:diarioup/src/domain/profile/gallery_image_selector.dart';
import 'package:diarioup/src/domain/profile/profile_customization.dart';
import 'package:diarioup/src/domain/repositories/profile_customization_repository.dart';
import 'package:diarioup/src/domain/auth/auth_credentials.dart';
import 'package:diarioup/src/domain/auth/auth_result.dart';
import 'package:diarioup/src/domain/errors/didup_failure.dart';
import 'package:diarioup/src/domain/repositories/didup_repository.dart';
import 'package:diarioup/src/presentation/l10n/app_copy.dart';
import 'package:diarioup/src/presentation/providers/app_providers.dart';
import 'package:diarioup/src/domain/reminders/reminder_plan.dart';
import 'package:diarioup/src/domain/reminders/reminder_service.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;

import '../support/test_didup_repository.dart';

void main() {
  testWidgets('il rifiuto Argo resta nel login con un errore leggibile', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          didupRepositoryProvider.overrideWith(
            (ref) async => _RejectingDidupRepository(),
          ),
          diagnosticRecorderProvider.overrideWith((ref) => (area, code) {}),
        ],
        child: const DiarioUpApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(AppCopy.start));
    await tester.tap(find.text(AppCopy.start));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, AppCopy.schoolCode),
      'TEST0000',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, AppCopy.username),
      'utente-errato',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, AppCopy.password),
      'password-errata',
    );
    await tester.tap(find.text(AppCopy.login));
    await tester.pumpAndSettle();

    expect(
      find.text('Argo non ha accettato le credenziali inserite.'),
      findsOneWidget,
    );
    expect(find.textContaining(AppCopy.dashboardGreeting), findsNothing);
  });

  testWidgets('onboarding, login e dashboard sono navigabili', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final database = AppDatabase(NativeDatabase.memory());
    final customizationRepository = _MemoryCustomizationRepository();
    addTearDown(database.close);
    addTearDown(customizationRepository.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWith((ref) async => database),
          didupRepositoryProvider.overrideWith(
            (ref) async => TestDidupRepository(database: database),
          ),
          reminderServiceProvider.overrideWith(
            (ref) => _GrantedReminderService(),
          ),
          profileCustomizationRepositoryProvider.overrideWith(
            (ref) async => customizationRepository,
          ),
          galleryImageSelectorProvider.overrideWith(
            (ref) => _SyntheticGalleryImageSelector(),
          ),
        ],
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
      'TEST0000',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, AppCopy.username),
      'utente-test',
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
    expect(find.text('Leggere il capitolo assegnato'), findsOneWidget);

    await tester.tap(find.text('Leggere il capitolo assegnato'));
    await tester.pumpAndSettle();
    expect(find.text(AppCopy.homeworkDetail), findsOneWidget);
    expect(find.text(AppCopy.sourceDate), findsOneWidget);
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(find.text(AppCopy.undo), findsOneWidget);
    expect(find.text(AppCopy.saveNote), findsOneWidget);
    await tester.tap(find.text(AppCopy.undo));
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(find.byType(Checkbox).first).value, isFalse);
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppCopy.saveNote));
    await tester.pumpAndSettle();
    expect(find.text(AppCopy.noteSaved), findsOneWidget);
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(find.byType(Checkbox).first).value, isFalse);
    await tester.scrollUntilVisible(
      find.text(AppCopy.personalNote),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(AppCopy.personalNote), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(find.text(AppCopy.undo), findsOneWidget);
    await tester.tap(find.text(AppCopy.undo));
    await tester.pumpAndSettle();
    expect(find.text('Leggere il capitolo assegnato'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, AppCopy.searchHomework),
      'Matematica',
    );
    await tester.pumpAndSettle();
    expect(find.text('Esercizi 12–18'), findsOneWidget);
    expect(find.text('Leggere il capitolo assegnato'), findsNothing);

    await tester.tap(find.text(AppCopy.subjects));
    await tester.pumpAndSettle();
    expect(find.text('Italiano'), findsOneWidget);
    expect(find.text('Matematica'), findsOneWidget);

    await tester.tap(find.text(AppCopy.settings));
    await tester.pumpAndSettle();
    expect(find.text(AppCopy.personalization), findsOneWidget);
    expect(find.text(AppCopy.profilePhoto), findsOneWidget);
    expect(find.text(AppCopy.diaryBackground), findsOneWidget);
    expect(find.text(AppCopy.enableReminders), findsOneWidget);
    expect(find.text(AppCopy.reminderTime), findsOneWidget);

    await tester.ensureVisible(find.text(AppCopy.chooseImage).first);
    await tester.tap(find.text(AppCopy.chooseImage).first);
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(CircleAvatar).first,
        matching: find.byType(Image),
      ),
      findsOneWidget,
    );

    await tester.ensureVisible(find.text(AppCopy.chooseImage));
    await tester.tap(find.text(AppCopy.chooseImage));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppCopy.agenda));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsWidgets);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}

final class _RejectingDidupRepository implements DidupRepository {
  @override
  Future<AuthResult> login(AuthCredentials credentials) async =>
      throw const AuthenticationFailure();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _SyntheticGalleryImageSelector implements GalleryImageSelector {
  @override
  Future<Uint8List?> select(ProfileImageKind kind) async {
    final source = image.Image(width: 24, height: 24);
    image.fill(source, color: image.ColorRgb8(79, 70, 229));
    return Uint8List.fromList(image.encodePng(source));
  }
}

final class _MemoryCustomizationRepository
    implements ProfileCustomizationRepository {
  final _changes = StreamController<ProfileCustomization>.broadcast();
  var _value = const ProfileCustomization();
  final _bytesByPath = <String, Uint8List>{};

  @override
  Stream<ProfileCustomization> watch(String profileId) async* {
    yield _value;
    yield* _changes.stream;
  }

  @override
  Future<Uint8List?> loadImage(String relativePath) async =>
      _bytesByPath[relativePath];

  @override
  Future<void> saveImage({
    required String profileId,
    required ProfileImageKind kind,
    required Uint8List bytes,
  }) async {
    final relativePath = switch (kind) {
      ProfileImageKind.profile => 'personalization/profile.jpg',
      ProfileImageKind.diaryBackground => 'personalization/background.jpg',
    };
    _bytesByPath[relativePath] = bytes;
    _value = switch (kind) {
      ProfileImageKind.profile => ProfileCustomization(
        profileImagePath: relativePath,
        diaryBackgroundPath: _value.diaryBackgroundPath,
      ),
      ProfileImageKind.diaryBackground => ProfileCustomization(
        profileImagePath: _value.profileImagePath,
        diaryBackgroundPath: relativePath,
      ),
    };
    _changes.add(_value);
  }

  @override
  Future<void> removeImage({
    required String profileId,
    required ProfileImageKind kind,
  }) async {}

  Future<void> close() => _changes.close();
}

final class _GrantedReminderService implements ReminderService {
  @override
  Future<void> initialize() async {}

  @override
  Future<ReminderPermissionStatus> permissionStatus() async =>
      ReminderPermissionStatus.granted;

  @override
  Future<ReminderPermissionStatus> requestPermission() async =>
      ReminderPermissionStatus.granted;

  @override
  Future<bool> openNotificationSettings() async => true;

  @override
  Future<void> replaceSchedule(List<ReminderPlanEntry> entries) async {}

  @override
  Future<void> cancelAll() async {}
}
