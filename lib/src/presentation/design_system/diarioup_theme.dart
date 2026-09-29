import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'diarioup_tokens.dart';

abstract final class DiarioUpTheme {
  static ThemeData light({Color? primaryColor, Color? backgroundColor}) =>
      _build(
        Brightness.light,
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
      );

  static ThemeData dark({Color? primaryColor, Color? backgroundColor}) =>
      _build(
        Brightness.dark,
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
      );

  static SystemUiOverlayStyle systemUiOverlayStyle(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDark
          ? DiarioUpColors.superficieScura
          : DiarioUpColors.superficie,
      systemNavigationBarIconBrightness: isDark
          ? Brightness.light
          : Brightness.dark,
    );
  }

  static ThemeData _build(
    Brightness brightness, {
    Color? primaryColor,
    Color? backgroundColor,
  }) {
    final primary = primaryColor ?? DiarioUpColors.indaco;
    final requestedDark = brightness == Brightness.dark;
    final selectedBackground = backgroundColor;
    final selectedBackgroundIsDark =
        selectedBackground != null &&
        selectedBackground.computeLuminance() < 0.35;
    final effectiveDark = requestedDark || selectedBackgroundIsDark;
    final effectiveBrightness = effectiveDark
        ? Brightness.dark
        : Brightness.light;
    final background = requestedDark
        ? selectedBackgroundIsDark
              ? selectedBackground
              : DiarioUpColors.inchiostro
        : selectedBackground ?? DiarioUpColors.sfondo;
    final surface = effectiveDark
        ? Color.alphaBlend(
            DiarioUpColors.superficie.withValues(alpha: 0.08),
            background,
          )
        : DiarioUpColors.superficie;
    final onSurface = effectiveDark
        ? DiarioUpColors.superficie
        : DiarioUpColors.inchiostro;
    final outline = effectiveDark
        ? Color.alphaBlend(
            DiarioUpColors.superficie.withValues(alpha: 0.24),
            background,
          )
        : DiarioUpColors.bordo;
    final onPrimary = primary.computeLuminance() > 0.55
        ? DiarioUpColors.inchiostro
        : DiarioUpColors.superficie;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: effectiveBrightness,
        ).copyWith(
          primary: primary,
          onPrimary: onPrimary,
          secondary: DiarioUpColors.verdePetrolio,
          tertiary: DiarioUpColors.ambra,
          surface: surface,
          onSurface: onSurface,
          outline: outline,
          error: DiarioUpColors.ambra,
        );

    const baseTextTheme = TextTheme(
      displaySmall: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: effectiveBrightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Inter',
      textTheme: baseTextTheme.apply(
        bodyColor: onSurface,
        displayColor: onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: systemUiOverlayStyle(effectiveBrightness),
        titleTextStyle: baseTextTheme.titleLarge?.copyWith(color: onSurface),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DiarioUpSpacing.md),
          side: BorderSide(color: outline),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DiarioUpSpacing.md,
          vertical: DiarioUpSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DiarioUpSpacing.sm),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DiarioUpSpacing.sm),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DiarioUpSpacing.sm),
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          side: primary.computeLuminance() > 0.9
              ? BorderSide(color: outline)
              : null,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(
            horizontal: DiarioUpSpacing.lg,
            vertical: DiarioUpSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DiarioUpSpacing.sm),
          ),
          textStyle: baseTextTheme.labelLarge,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: 0.16),
        labelTextStyle: WidgetStatePropertyAll(baseTextTheme.labelMedium),
      ),
      dividerColor: outline,
    );
  }
}
