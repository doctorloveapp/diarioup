import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../presentation/design_system/diarioup_theme.dart';
import '../presentation/l10n/app_copy.dart';
import '../presentation/routing/app_router.dart';

final class DiarioUpApp extends ConsumerWidget {
  const DiarioUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: AppCopy.appName,
      debugShowCheckedModeBanner: false,
      theme: DiarioUpTheme.light(),
      darkTheme: DiarioUpTheme.dark(),
      themeMode: ThemeMode.system,
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
