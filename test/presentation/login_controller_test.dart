import 'package:diarioup/diarioup.dart';
import 'package:diarioup/src/presentation/controllers/login_controller.dart';
import 'package:diarioup/src/presentation/l10n/app_copy.dart';
import 'package:diarioup/src/presentation/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final (failure, expected) in <(DidupFailure, String)>[
    (const RequestTimeoutFailure(), AppCopy.loginRequestTimeout),
    (const NetworkFailure(), AppCopy.loginNetworkUnavailable),
    (const AuthenticationFailure(), const AuthenticationFailure().message),
  ]) {
    test(
      'il login distingue ${failure.runtimeType} senza accettare il profilo',
      () async {
        final container = ProviderContainer(
          overrides: [
            authenticateWithDidupProvider.overrideWith(
              (ref) async => AuthenticateWithDidup(_FailingRepository(failure)),
            ),
            diagnosticRecorderProvider.overrideWith((ref) => (area, code) {}),
          ],
        );
        addTearDown(container.dispose);
        await container
            .read(loginControllerProvider.notifier)
            .submit(
              schoolCode: 'TEST0000',
              username: 'utente-sintetico',
              password: 'password-sintetica',
            );
        final state = container.read(loginControllerProvider);
        expect(state.errorMessage, expected);
        expect(state.isLoading, isFalse);
        expect(state.profiles, isEmpty);
      },
    );
  }
}

final class _FailingRepository implements DidupRepository {
  const _FailingRepository(this.failure);
  final DidupFailure failure;

  @override
  Future<AuthResult> login(AuthCredentials credentials) async => throw failure;

  @override
  Never noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('Operazione non prevista.');
}
