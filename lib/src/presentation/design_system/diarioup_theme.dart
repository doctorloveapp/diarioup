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

  static ThemeData dark({Color? primaryColor}) =>
      _build(Brightness.dark, primaryColor: primaryColor);

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
    final isDark = brightness == Brightness.dark;
    final primary = primaryColor ?? DiarioUpColors.indaco;
    final background = isDark
        ? DiarioUpColors.inchiostro
        : backgroundColor ?? DiarioUpColors.sfondo;
    final surface = isDark
        ? DiarioUpColors.superficieScura
        : DiarioUpColors.superficie;
    final onSurface = isDark
        ? DiarioUpColors.superficie
        : DiarioUpColors.inchiostro;
    final outline = isDark ? DiarioUpColors.bordoScuro : DiarioUpColors.bordo;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: brightness,
        ).copyWith(
          primary: primary,
          onPrimary: DiarioUpColors.superficie,
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
      brightness: brightness,
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
        systemOverlayStyle: systemUiOverlayStyle(brightness),
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
