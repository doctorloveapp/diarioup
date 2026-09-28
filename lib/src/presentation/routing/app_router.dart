import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/app_flow_controller.dart';
import '../pages/dashboard_page.dart';
import '../pages/login_page.dart';
import '../pages/onboarding_page.dart';

abstract final class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
}

final class _RouterRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final routerRefreshProvider = Provider<_RouterRefresh>((Ref ref) {
  final refresh = _RouterRefresh();
  ref.listen<AppFlowState>(
    appFlowProvider,
    (AppFlowState? previous, AppFlowState next) => refresh.refresh(),
  );
  ref.onDispose(refresh.dispose);
  return refresh;
});

final appRouterProvider = Provider<GoRouter>((Ref ref) {
  final refresh = ref.watch(routerRefreshProvider);
  final router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    refreshListenable: refresh,
    redirect: (context, state) {
      final flow = ref.read(appFlowProvider);
      final path = state.uri.path;
      if (!flow.onboardingCompleted && path != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }
      if (flow.onboardingCompleted &&
          !flow.isAuthenticated &&
          path != AppRoutes.login) {
        return AppRoutes.login;
      }
      if (flow.isAuthenticated && path != AppRoutes.dashboard) {
        return AppRoutes.dashboard;
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
