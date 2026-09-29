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

abstract final class DiarioUpSubjectColors {
  static const List<Color> palette = <Color>[
    DiarioUpColors.indaco,
    DiarioUpColors.verdePetrolio,
    DiarioUpColors.ambra,
    DiarioUpColors.inchiostro,
    DiarioUpColors.testoSecondario,
  ];

  static Color resolve({int? storedValue, required String identity}) {
    if (storedValue != null) return Color(storedValue);
    final hash = identity.codeUnits.fold<int>(0, (value, unit) => value + unit);
    return palette[hash % palette.length];
  }
}

abstract final class DiarioUpThemeChoices {
  static const List<Color> primary = <Color>[
    DiarioUpColors.superficie,
    DiarioUpColors.indaco,
    DiarioUpColors.verdePetrolio,
    DiarioUpColors.ambra,
    DiarioUpColors.inchiostro,
    Color(0xFFB91C1C), // rosso
    Color(0xFFC2410C), // arancione
    Color(0xFF854D0E), // giallo
    Color(0xFF15803D), // verde
    Color(0xFF1D4ED8), // blu
    Color(0xFF7E22CE), // violetto
  ];

  static List<Color> get background => <Color>[
    DiarioUpColors.sfondo,
    DiarioUpColors.superficie,
    Color.alphaBlend(
      DiarioUpColors.testoSecondario.withValues(alpha: 0.06),
      DiarioUpColors.sfondo,
    ),
    Color.alphaBlend(
      DiarioUpColors.indaco.withValues(alpha: 0.06),
      DiarioUpColors.sfondo,
    ),
    const Color(0xFFDBEAFE),
    const Color(0xFFDCFCE7),
    const Color(0xFFFEF3C7),
    const Color(0xFFFCE7F3),
    const Color(0xFFF3E8FF),
    const Color(0xFF172554),
    const Color(0xFF052E16),
    const Color(0xFF450A0A),
    const Color(0xFF3B0764),
    const Color(0xFF0F172A),
  ];
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
