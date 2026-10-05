import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../domain/entities/dex_card.dart';
import 'card_caption.dart';
import 'card_favourites.dart';
import 'card_metrics.dart';
import 'card_rarity_label.dart';
import 'rarity_style.dart';

class CardFace extends StatelessWidget {
  const CardFace({required this.card, this.compact = false, super.key});

  final DexCard card;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final tone = card.rarity.color(palette);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.nebula,
        borderRadius: BorderRadius.circular(CardMetrics.radius),
        border: Border.all(color: tone, width: CardMetrics.borderWidth),
        boxShadow: [
          BoxShadow(
            color: tone.withValues(alpha: 0.55),
            blurRadius: compact ? 8 : 18,
            offset: const Offset(3, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          CardMetrics.radius - CardMetrics.borderWidth,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            LayoutBuilder(
              builder: (context, box) => AnimePoster(
                title: card.name,
                imageUrl: card.imageUrl,
                width: box.maxWidth,
                height: box.maxHeight,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CardCaption(card: card, compact: compact),
            ),
            Positioned(
              top: AppSpacing.sm,
              left: AppSpacing.sm,
              right: AppSpacing.sm,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: CardRarityLabel(rarity: card.rarity)),
                  const SizedBox(width: AppSpacing.xs),
                  CardFavourites(count: card.favourites, compact: compact),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
