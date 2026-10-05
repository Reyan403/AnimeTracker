import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../domain/entities/drawn_card.dart';
import '../card/card_metrics.dart';
import '../card/rarity_style.dart';

class TrayCard extends StatelessWidget {
  const TrayCard({this.drawn, super.key});

  final DrawnCard? drawn;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final entry = drawn;
    final tone = entry == null
        ? palette.starGlow.withValues(alpha: 0.35)
        : entry.card.rarity.color(palette);

    return AspectRatio(
      aspectRatio: CardMetrics.aspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.nebula,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: tone, width: 2),
        ),
        child: entry == null
            ? null
            : Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LayoutBuilder(
                      builder: (context, box) => AnimePoster(
                        title: entry.card.title,
                        imageUrl: entry.card.posterUrl,
                        width: box.maxWidth,
                        height: box.maxHeight,
                      ),
                    ),
                  ),
                  if (entry.isNew)
                    Positioned(
                      top: 3,
                      right: 3,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: palette.candy,
                          shape: BoxShape.circle,
                          border: Border.all(color: palette.starGlow),
                        ),
                        child: const SizedBox.square(dimension: 10),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
