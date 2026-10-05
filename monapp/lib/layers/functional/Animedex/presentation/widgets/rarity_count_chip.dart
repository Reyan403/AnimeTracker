import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/card_rarity.dart';
import '../card/rarity_style.dart';

class RarityCountChip extends StatelessWidget {
  const RarityCountChip({required this.rarity, required this.count, super.key});

  final CardRarity rarity;
  final int count;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: rarity.color(palette), width: 2.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 2,
          vertical: AppSpacing.xs + 1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, size: 16, color: rarity.color(palette)),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '${rarity.label(l10n)} $count',
              style: theme.textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
