import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/auth/auth_credentials.dart';
import '../../domain/auth/student_profile.dart';
import '../../domain/errors/didup_failure.dart';
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
      final result = await ref.read(authenticateWithDidupProvider)(
        AuthCredentials(
          schoolCode: schoolCode,
          username: username,
          password: password,
        ),
      );
      final profiles = List<StudentProfile>.unmodifiable(result.profiles);
      state = LoginState(profiles: profiles);
      if (profiles.length == 1) {
        ref.read(appFlowProvider.notifier).authenticate(profiles.single);
      }
    } on DidupFailure catch (failure) {
      state = LoginState(errorMessage: failure.message);
    } on ArgumentError {
      state = const LoginState(errorMessage: AppCopy.genericLoginError);
    }
  }

  void selectProfile(StudentProfile profile) {
    ref.read(appFlowProvider.notifier).authenticate(profile);
    state = LoginState(profiles: state.profiles);
  }
}

final loginControllerProvider = NotifierProvider<LoginController, LoginState>(
  LoginController.new,
);
