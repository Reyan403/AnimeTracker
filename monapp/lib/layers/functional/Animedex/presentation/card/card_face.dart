import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../domain/entities/dex_card.dart';
import 'card_metrics.dart';
import 'rarity_stars.dart';
import 'rarity_style.dart';

class CardFace extends StatelessWidget {
  const CardFace({
    required this.card,
    this.heroTag,
    this.compact = false,
    super.key,
  });

  final DexCard card;
  final String? heroTag;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final tone = card.rarity.color(palette);
    final radius = BorderRadius.circular(CardMetrics.radius);
    final labelInk =
        ThemeData.estimateBrightnessForColor(tone) == Brightness.dark
        ? palette.starGlow
        : palette.nebula;
    final titleStyle = compact
        ? theme.textTheme.titleLarge?.copyWith(
            fontSize: CardMetrics.compactTitleSize,
          )
        : theme.textTheme.titleLarge;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.nebula,
        borderRadius: radius,
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
                title: card.title,
                imageUrl: card.posterUrl,
                heroTag: heroTag,
                width: box.maxWidth,
                height: box.maxHeight,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DecoratedBox(
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
                        card.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: titleStyle?.copyWith(color: palette.starGlow),
                      ),
                      if (!compact)
                        Text(
                          '${card.format} · ${card.year}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: palette.starGlow,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.sm,
              left: AppSpacing.sm,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: tone,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: palette.nebula, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  child: Text(
                    card.rarity.label(l10n),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: labelInk,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
