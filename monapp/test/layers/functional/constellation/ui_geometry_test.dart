import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/shooting_star_drawing.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/star_layout.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/star_motion.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/star_palette.dart';
import 'package:monapp/layers/technical/Theme/app_palette.dart';

import 'ui_support.dart';

void main() {
  const size = Size(400, 800);
  const inset = EdgeInsets.only(top: 100);
  final stars = sampleConstellation.stars;

  group('StarLayout', () {
    test('place les étoiles dans la zone utile', () {
      final area = StarLayout.areaOf(size, inset);

      for (final star in stars) {
        expect(area.contains(StarLayout.positionOf(star, size, inset)), isTrue);
      }
    });

    test('la taille croît avec le poids', () {
      expect(
        StarLayout.radiusOf(stars[0]),
        greaterThan(StarLayout.radiusOf(stars[2])),
      );
    });

    test('trouve l étoile touchée avec une marge de tolérance', () {
      final target = StarLayout.positionOf(stars[1], size, inset);

      expect(
        StarLayout.hitTest(stars, target + const Offset(15, 10), size, inset),
        2,
      );
    });

    test('ne trouve rien loin des étoiles', () {
      expect(
        StarLayout.hitTest(stars, const Offset(390, 110), size, inset),
        isNull,
      );
    });

    test('choisit l étoile la plus proche', () {
      final first = StarLayout.positionOf(stars[0], size, inset);
      final second = StarLayout.positionOf(stars[1], size, inset);
      final between = Offset.lerp(first, second, 0.9)!;

      expect(
        StarLayout.hitTest(stars, between, size, inset, tolerance: 400),
        2,
      );
    });
  });

  group('StarMotion', () {
    test('révèle les étoiles progressivement', () {
      expect(StarMotion.appear(0, 0, 10), lessThan(0.1));
      expect(StarMotion.appear(0, 9, 10), 0);
      expect(StarMotion.appear(StarMotion.restTime, 9, 10), closeTo(1, 0.001));
    });

    test('le scintillement reste dans une plage douce', () {
      for (var time = 0.0; time < 20; time += 0.5) {
        expect(StarMotion.twinkle(time, 3), inInclusiveRange(0.5, 1));
      }
    });

    test('l étoile filante n apparaît que dans sa fenêtre', () {
      expect(StarMotion.shootingProgress(1), isNull);
      expect(StarMotion.shootingProgress(8.45), closeTo(0.5, 0.01));
      expect(StarMotion.shootingProgress(11 + 8.45), closeTo(0.5, 0.01));
      expect(StarMotion.shootingProgress(10), isNull);
    });
  });

  group('StarPalette', () {
    test('cycle dans les couleurs de la palette selon l index', () {
      final cycle = StarPalette.cycleOf(AppPalette.light);

      expect(StarPalette.colorAt(AppPalette.light, 0), cycle.first);
      expect(StarPalette.colorAt(AppPalette.light, cycle.length), cycle.first);
      expect(StarPalette.colorAt(AppPalette.light, 1), cycle[1]);
    });

    test('associe chaque genre à sa couleur', () {
      final colors = StarPalette.colorsOf(
        AppPalette.dark,
        sampleConstellation.genres,
      );

      expect(colors['action'], StarPalette.colorAt(AppPalette.dark, 0));
      expect(colors['emotional'], StarPalette.colorAt(AppPalette.dark, 1));
    });
  });

  group('ShootingStarDrawing', () {
    test('dessine pendant sa fenêtre et reste muet en dehors', () {
      final canvas = Canvas(PictureRecorder());

      expect(() {
        ShootingStarDrawing.paint(
          canvas,
          Paint(),
          size,
          8.4,
          const Color(0xFFFFFFFF),
        );
        ShootingStarDrawing.paint(
          canvas,
          Paint(),
          size,
          2,
          const Color(0xFFFFFFFF),
        );
      }, returnsNormally);
    });
  });
}
