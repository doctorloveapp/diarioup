import 'package:flutter/material.dart';

abstract final class DiarioUpColors {
  static const Color indaco = Color(0xFF4F46E5);
  static const Color inchiostro = Color(0xFF111827);
  static const Color verdePetrolio = Color(0xFF0F766E);
  static const Color ambra = Color(0xFFF59E0B);
  static const Color sfondo = Color(0xFFF8FAFC);
  static const Color superficie = Color(0xFFFFFFFF);
  static const Color testoSecondario = Color(0xFF475569);
  static const Color bordo = Color(0xFFCBD5E1);

  static Color get superficieScura =>
      Color.alphaBlend(superficie.withValues(alpha: 0.08), inchiostro);

  static Color get bordoScuro =>
      Color.alphaBlend(superficie.withValues(alpha: 0.24), inchiostro);
}

abstract final class DiarioUpSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

abstract final class DiarioUpMotion {
  static const Duration micro = Duration(milliseconds: 120);
  static const Duration standard = Duration(milliseconds: 200);
  static const Duration emphasis = Duration(milliseconds: 300);
}
