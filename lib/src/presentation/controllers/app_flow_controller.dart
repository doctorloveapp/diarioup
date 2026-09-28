import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/auth/student_profile.dart';

final class AppFlowState {
  const AppFlowState({this.onboardingCompleted = false, this.activeProfile});

  final bool onboardingCompleted;
  final StudentProfile? activeProfile;

  bool get isAuthenticated => activeProfile != null;

  AppFlowState copyWith({
    bool? onboardingCompleted,
    StudentProfile? activeProfile,
    bool clearProfile = false,
  }) {
    return AppFlowState(
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      activeProfile: clearProfile ? null : activeProfile ?? this.activeProfile,
    );
  }
}

final class AppFlowController extends Notifier<AppFlowState> {
  @override
  AppFlowState build() => const AppFlowState();

  void completeOnboarding() {
    state = state.copyWith(onboardingCompleted: true);
  }

  void authenticate(StudentProfile profile) {
    state = state.copyWith(onboardingCompleted: true, activeProfile: profile);
  }

  void signOut() {
    state = state.copyWith(clearProfile: true);
  }
}

final appFlowProvider = NotifierProvider<AppFlowController, AppFlowState>(
  AppFlowController.new,
);
