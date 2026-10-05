import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/card_rarity.dart';
import '../card/rarity_style.dart';
import 'dex_filter_chip.dart';

class RarityFilterBar extends StatelessWidget {
  const RarityFilterBar({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final CardRarity? selected;
  final ValueChanged<CardRarity?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        DexFilterChip(
          label: l10n.dexFilterAll,
          tone: Theme.of(context).colorScheme.primary,
          isSelected: selected == null,
          onTap: () => onSelected(null),
        ),
        for (final rarity in CardRarity.values)
          DexFilterChip(
            label: rarity.label(l10n),
            tone: rarity.color(palette),
            isSelected: selected == rarity,
            onTap: () => onSelected(rarity),
          ),
      ],
    );
  }
}
