import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/technical/Theme/app_palette.dart';
import 'package:monapp/layers/technical/Theme/app_theme.dart';

double contrast(Color first, Color second) {
  final lighter = first.computeLuminance() > second.computeLuminance()
      ? first
      : second;
  final darker = identical(lighter, first) ? second : first;

  return (lighter.computeLuminance() + 0.05) /
      (darker.computeLuminance() + 0.05);
}

void main() {
  for (final entry in {
    'clair': AppTheme.light,
    'sombre': AppTheme.dark,
  }.entries) {
    group('thème ${entry.key}', () {
      final theme = entry.value;
      final scheme = theme.colorScheme;
      final palette = theme.extension<AppPalette>()!;

      test('expose la palette étendue', () {
        expect(theme.extension<AppPalette>(), isNotNull);
      });

      test('texte principal sur surface atteint le contraste AA', () {
        expect(contrast(scheme.onSurface, scheme.surface), greaterThan(4.5));
      });

      test('texte sur couleur primaire atteint le contraste AA', () {
        expect(contrast(scheme.onPrimary, scheme.primary), greaterThan(4.5));
      });

      test('texte secondaire sur surface atteint le contraste AA', () {
        expect(
          contrast(scheme.onSurfaceVariant, scheme.surface),
          greaterThan(4.5),
        );
      });

      test('couleurs de statut lisibles sur la surface des cartes', () {
        for (final color in [
          palette.toWatch,
          palette.watching,
          palette.completed,
        ]) {
          expect(contrast(color, palette.cardSurface), greaterThan(4.5));
        }
      });

      test('initiales lisibles sur le visuel de repli', () {
        expect(
          contrast(palette.posterFallbackInk, palette.posterFallback),
          greaterThan(4.5),
        );
      });
    });
  }

  test('lerp et copyWith conservent la palette', () {
    final blended = AppPalette.light.lerp(AppPalette.dark, 0.5);

    expect(blended.cardSurface, isNot(AppPalette.light.cardSurface));
    expect(
      AppPalette.light.copyWith(toWatch: Colors.red).toWatch,
      Colors.red,
    );
    expect(AppPalette.light.lerp(null, 0.5), AppPalette.light);
  });
}
