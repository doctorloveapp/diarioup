import 'package:diarioup/src/presentation/design_system/diarioup_theme.dart';
import 'package:diarioup/src/presentation/design_system/diarioup_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('la palette principale contiene i sette colori dell arcobaleno', () {
    final values = DiarioUpThemeChoices.primary
        .map((color) => color.toARGB32())
        .toSet();

    expect(
      values,
      containsAll(<int>{
        const Color(0xFFB91C1C).toARGB32(),
        const Color(0xFFC2410C).toARGB32(),
        const Color(0xFF854D0E).toARGB32(),
        const Color(0xFF15803D).toARGB32(),
        const Color(0xFF1D4ED8).toARGB32(),
        DiarioUpColors.indaco.toARGB32(),
        const Color(0xFF7E22CE).toARGB32(),
      }),
    );
  });

  test('uno sfondo scuro attiva automaticamente un tema leggibile', () {
    const background = Color(0xFF172554);
    final theme = DiarioUpTheme.light(backgroundColor: background);

    expect(theme.scaffoldBackgroundColor, background);
    expect(theme.brightness, Brightness.dark);
    expect(theme.colorScheme.onSurface, DiarioUpColors.superficie);
    expect(
      DiarioUpThemeChoices.background.any(
        (color) => color.computeLuminance() < 0.1,
      ),
      isTrue,
    );
    expect(
      DiarioUpThemeChoices.background.any(
        (color) => color.computeLuminance() > 0.8,
      ),
      isTrue,
    );
  });
}
