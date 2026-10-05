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
    required this.counts,
    required this.onSelected,
    super.key,
  });

  final CardRarity? selected;
  final Map<CardRarity, int> counts;
  final ValueChanged<CardRarity?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final total = counts.values.fold<int>(0, (sum, count) => sum + count);

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        DexFilterChip(
          label: l10n.dexFilterAll,
          tone: Theme.of(context).colorScheme.primary,
          icon: Icons.auto_awesome_rounded,
          count: total,
          isSelected: selected == null,
          onTap: () => onSelected(null),
        ),
        for (final rarity in CardRarity.values)
          DexFilterChip(
            label: rarity.label(l10n),
            tone: rarity.color(palette),
            count: counts[rarity] ?? 0,
            isSelected: selected == rarity,
            onTap: () => onSelected(rarity),
          ),
      ],
    );
  }
}
