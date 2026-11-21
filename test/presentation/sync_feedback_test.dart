import 'dart:async';

import 'package:diarioup/diarioup.dart';
import 'package:diarioup/src/presentation/controllers/app_flow_controller.dart';
import 'package:diarioup/src/presentation/formatters/sync_feedback.dart';
import 'package:diarioup/src/presentation/l10n/app_copy.dart';
import 'package:diarioup/src/presentation/providers/app_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_didup_repository.dart';

void main() {
  test('una sessione rifiutata richiede un nuovo accesso, non un retry', () {
    for (final error in <DidupFailure>[
      const SessionExpiredFailure('private-marker'),
      const AuthenticationFailure('private-marker'),
    ]) {
      expect(syncRequiresAuthentication(error), isTrue);
      expect(syncFailureMessage(error), AppCopy.syncSignInAgain);
      expect(syncFailureMessage(error), isNot(contains('private-marker')));
    }
  });

  test(
    'rete e formato errato non richiedono logout né espongono eccezioni',
    () {
      final cases = <Object, String>{
        const NetworkFailure('private-marker'): AppCopy.loginNetworkUnavailable,
        const RequestTimeoutFailure('private-marker'):
            AppCopy.loginRequestTimeout,
        const PermissionDeniedFailure('private-marker'):
            AppCopy.syncPermissionDenied,
        const RateLimitedFailure(message: 'private-marker'):
            AppCopy.syncRateLimited,
        const InvalidPayloadFailure('private-marker'): AppCopy.syncPayloadError,
        const CompatibilityFailure('private-marker'):
            AppCopy.syncCompatibilityError,
        StateError('private-marker'): AppCopy.syncError,
      };
      for (final entry in cases.entries) {
        expect(syncRequiresAuthentication(entry.key), isFalse);
        expect(syncFailureMessage(entry.key), entry.value);
        expect(
          syncFailureMessage(entry.key),
          isNot(contains('private-marker')),
        );
      }
    },
  );

  test(
    'il nuovo accesso allo stesso profilo riprova la sincronizzazione',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = TestDidupRepository(database: database);
      final login = await repository.login(
        AuthCredentials(
          schoolCode: 'TEST0000',
          username: 'utente-test',
          password: 'solo-test',
        ),
      );
      final profile = login.profiles.single;
      var attempts = 0;
      final container = ProviderContainer(
        overrides: [
          didupRepositoryProvider.overrideWith((ref) async => repository),
          syncProfileProvider(profile.sourceProfileId).overrideWith((
            ref,
          ) async {
            attempts++;
            if (attempts == 1) throw const SessionExpiredFailure();
            return DidupSyncResult(
              savedHomeworkCount: 1,
              completedAt: DateTime.utc(2026, 11, 21),
              wasPartial: false,
            );
          }),
        ],
      );
      addTearDown(container.dispose);
      final restored = Completer<void>();
      container.listen(appFlowProvider, (_, next) {
        if (!next.isRestoring && !restored.isCompleted) restored.complete();
      });
      await restored.future;
      container.listen(
        syncProfileProvider(profile.sourceProfileId),
        (_, next) {},
      );
      await expectLater(
        container.read(syncProfileProvider(profile.sourceProfileId).future),
        throwsA(isA<SessionExpiredFailure>()),
      );
      await container.read(appFlowProvider.notifier).authenticate(profile);
      final result = await container.read(
        syncProfileProvider(profile.sourceProfileId).future,
      );
      expect(result.savedHomeworkCount, 1);
      expect(attempts, 2);
      expect(container.read(appFlowProvider).activeProfile, profile);
    },
  );
}
