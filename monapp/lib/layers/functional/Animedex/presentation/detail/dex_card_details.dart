import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/dex_card.dart';
import '../card/favourites_format.dart';
import '../card/rarity_stars.dart';
import '../card/rarity_style.dart';

class DexCardDetails extends StatelessWidget {
  const DexCardDetails({required this.card, super.key});

  final DexCard card;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final native = card.nativeName;
    final anime = card.animeTitle;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          card.name,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        if (native != null && native.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            native,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: muted),
          ),
        ],
        if (anime != null && anime.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.dexDetailOrigin,
            style: theme.textTheme.labelMedium?.copyWith(color: muted),
          ),
          Text(
            anime,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RarityStars(rarity: card.rarity),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  card.rarity.label(l10n),
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_rounded, size: 18, color: palette.candy),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  l10n.dexDetailFavourites(
                    FavouritesFormat.of(l10n, card.favourites),
                  ),
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.dexDetailObtained(card.obtainedOn),
          style: theme.textTheme.bodySmall?.copyWith(color: muted),
        ),
      ],
    );
  }
}
