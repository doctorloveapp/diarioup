import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/auth/student_profile.dart';
import '../providers/app_providers.dart';

final class AppFlowState {
  const AppFlowState({
    this.isRestoring = true,
    this.onboardingCompleted = false,
    this.activeProfile,
  });

  final bool isRestoring;
  final bool onboardingCompleted;
  final StudentProfile? activeProfile;

  bool get isAuthenticated => activeProfile != null;

  AppFlowState copyWith({
    bool? isRestoring,
    bool? onboardingCompleted,
    StudentProfile? activeProfile,
    bool clearProfile = false,
  }) {
    return AppFlowState(
      isRestoring: isRestoring ?? this.isRestoring,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      activeProfile: clearProfile ? null : activeProfile ?? this.activeProfile,
    );
  }
}

final class AppFlowController extends Notifier<AppFlowState> {
  @override
  AppFlowState build() {
    unawaited(Future<void>.microtask(_restoreSession));
    return const AppFlowState();
  }

  Future<void> _restoreSession() async {
    try {
      final repository = await ref.read(didupRepositoryProvider.future);
      final profile = await repository.restoreActiveProfile();
      state = AppFlowState(
        isRestoring: false,
        onboardingCompleted: profile != null,
        activeProfile: profile,
      );
    } on Object {
      state = const AppFlowState(isRestoring: false);
    }
  }

  void completeOnboarding() {
    state = state.copyWith(onboardingCompleted: true);
  }

  Future<void> authenticate(StudentProfile profile) async {
    final repository = await ref.read(didupRepositoryProvider.future);
    await repository.rememberActiveProfile(profile.sourceProfileId);
    state = state.copyWith(onboardingCompleted: true, activeProfile: profile);
  }

  void signOut() {
    state = state.copyWith(clearProfile: true);
  }
}

final appFlowProvider = NotifierProvider<AppFlowController, AppFlowState>(
  AppFlowController.new,
);
