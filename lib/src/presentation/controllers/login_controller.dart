import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/auth/auth_credentials.dart';
import '../../domain/auth/student_profile.dart';
import '../../domain/errors/didup_failure.dart';
import '../../domain/diagnostics/diagnostic_event.dart';
import '../l10n/app_copy.dart';
import '../providers/app_providers.dart';
import 'app_flow_controller.dart';

final class LoginState {
  const LoginState({
    this.isLoading = false,
    this.profiles = const <StudentProfile>[],
    this.errorMessage,
  });

  final bool isLoading;
  final List<StudentProfile> profiles;
  final String? errorMessage;
}

final class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  Future<void> submit({
    required String schoolCode,
    required String username,
    required String password,
  }) async {
    state = const LoginState(isLoading: true);
    try {
      final authenticate = await ref.read(authenticateWithDidupProvider.future);
      final result = await authenticate(
        AuthCredentials(
          schoolCode: schoolCode,
          username: username,
          password: password,
        ),
      );
      final profiles = List<StudentProfile>.unmodifiable(result.profiles);
      state = LoginState(profiles: profiles);
      if (profiles.length == 1) {
        await ref.read(appFlowProvider.notifier).authenticate(profiles.single);
      }
    } on DidupFailure catch (failure) {
      _recordFailure();
      final message = switch (failure) {
        AuthenticationFailure() => failure.message,
        NetworkFailure() => AppCopy.loginNetworkUnavailable,
        _ => failure.message,
      };
      state = LoginState(errorMessage: message);
    } on ArgumentError {
      _recordFailure();
      state = const LoginState(errorMessage: AppCopy.genericLoginError);
    } on Object {
      _recordFailure();
      state = const LoginState(errorMessage: AppCopy.genericLoginError);
    }
  }

  void _recordFailure() {
    ref.read(diagnosticRecorderProvider)(
      DiagnosticArea.authentication,
      DiagnosticCode.authenticationFailed,
    );
  }

  Future<void> selectProfile(StudentProfile profile) async {
    final profiles = state.profiles;
    state = LoginState(isLoading: true, profiles: profiles);
    try {
      await ref.read(appFlowProvider.notifier).authenticate(profile);
      state = LoginState(profiles: profiles);
    } on Object {
      _recordFailure();
      state = LoginState(
        profiles: profiles,
        errorMessage: AppCopy.genericLoginError,
      );
    }
  }
}

final loginControllerProvider = NotifierProvider<LoginController, LoginState>(
  LoginController.new,
);
