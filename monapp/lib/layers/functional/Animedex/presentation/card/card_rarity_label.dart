import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/card_rarity.dart';
import 'rarity_style.dart';

class CardRarityLabel extends StatelessWidget {
  const CardRarityLabel({required this.rarity, super.key});

  final CardRarity rarity;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final tone = rarity.color(palette);
    final labelInk =
        ThemeData.estimateBrightnessForColor(tone) == Brightness.dark
        ? palette.starGlow
        : palette.nebula;

    return DecoratedBox(
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
          rarity.label(AppLocalizations.of(context)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(color: labelInk),
        ),
      ),
    );
  }
}
