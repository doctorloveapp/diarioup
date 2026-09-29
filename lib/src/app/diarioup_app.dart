import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../presentation/design_system/diarioup_theme.dart';
import '../presentation/design_system/diarioup_tokens.dart';
import '../presentation/controllers/app_flow_controller.dart';
import '../presentation/l10n/app_copy.dart';
import '../presentation/providers/app_providers.dart';
import '../presentation/routing/app_router.dart';
import '../domain/profile/profile_customization.dart';

final class DiarioUpApp extends ConsumerWidget {
  const DiarioUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final profileId = ref.watch(
      appFlowProvider.select((state) => state.activeProfile?.sourceProfileId),
    );
    final customization = profileId == null
        ? const ProfileCustomization()
        : ref.watch(profileCustomizationProvider(profileId)).asData?.value ??
              const ProfileCustomization();
    final primary = Color(
      customization.primaryColorValue ?? DiarioUpColors.indaco.toARGB32(),
    );
    final background = Color(
      customization.backgroundColorValue ?? DiarioUpColors.sfondo.toARGB32(),
    );
    final themeMode = switch (customization.themeMode) {
      DiaryThemeMode.system => ThemeMode.system,
      DiaryThemeMode.light => ThemeMode.light,
      DiaryThemeMode.dark => ThemeMode.dark,
    };
    return MaterialApp.router(
      title: AppCopy.appName,
      debugShowCheckedModeBanner: false,
      theme: DiarioUpTheme.light(
        primaryColor: primary,
        backgroundColor: background,
      ),
      darkTheme: DiarioUpTheme.dark(
        primaryColor: primary,
        backgroundColor: background,
      ),
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: DiarioUpTheme.systemUiOverlayStyle(
            Theme.of(context).brightness,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
