import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/dex_card.dart';
import 'card_metrics.dart';
import 'rarity_stars.dart';

class CardCaption extends StatelessWidget {
  const CardCaption({required this.card, this.compact = false, super.key});

  final DexCard card;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);
    final nameStyle = compact
        ? theme.textTheme.titleLarge?.copyWith(
            fontSize: CardMetrics.compactTitleSize,
          )
        : theme.textTheme.titleLarge;
    final anime = card.animeTitle;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, palette.nebula],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RarityStars(rarity: card.rarity, size: compact ? 14 : 18),
            Text(
              card.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: nameStyle?.copyWith(color: palette.starGlow),
            ),
            if (anime != null && anime.isNotEmpty)
              Text(
                anime,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: palette.starGlow.withValues(alpha: 0.78),
                  fontSize: compact ? CardMetrics.compactAnimeSize : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
