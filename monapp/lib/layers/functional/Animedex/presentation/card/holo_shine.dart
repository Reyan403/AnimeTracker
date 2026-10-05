import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_palette.dart';
import '../../domain/entities/card_rarity.dart';
import 'card_metrics.dart';
import 'rarity_style.dart';
import 'slide_gradient_transform.dart';

class HoloShine extends StatelessWidget {
  const HoloShine({
    required this.rarity,
    required this.phase,
    required this.tilt,
    super.key,
  });

  final CardRarity rarity;
  final Animation<double> phase;
  final ValueListenable<Offset> tilt;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final intensity = rarity.shineIntensity;
    final rainbow = [
      palette.candy,
      palette.sun,
      palette.sky,
      palette.rarityEpic,
      palette.candy,
    ].map((color) => color.withValues(alpha: intensity)).toList();
    final gloss = palette.starGlow.withValues(alpha: intensity * 1.6);

    return IgnorePointer(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(CardMetrics.radius),
        child: AnimatedBuilder(
          animation: Listenable.merge([phase, tilt]),
          builder: (context, _) {
            final slide = phase.value * 2 + tilt.value.dx * 0.6;
            final sweep = phase.value * 3 - 1.5 + tilt.value.dx;

            return Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: rainbow,
                      tileMode: TileMode.mirror,
                      transform: SlideGradientTransform(slide),
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.transparent, gloss, Colors.transparent],
                      stops: const [0.38, 0.5, 0.62],
                      transform: SlideGradientTransform(sweep),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
