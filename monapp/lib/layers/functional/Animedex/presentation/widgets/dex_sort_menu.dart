import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../cubit/dex_filter.dart';

extension DexSortLabel on DexSort {
  String label(AppLocalizations l10n) => switch (this) {
    DexSort.recent => l10n.dexSortRecent,
    DexSort.rarity => l10n.dexSortRarity,
    DexSort.name => l10n.dexSortName,
    DexSort.favourites => l10n.dexSortFavourites,
  };
}

class DexSortMenu extends StatelessWidget {
  const DexSortMenu({required this.sort, required this.onSelected, super.key});

  final DexSort sort;
  final ValueChanged<DexSort> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return PopupMenuButton<DexSort>(
      tooltip: l10n.dexSortLabel,
      initialValue: sort,
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final option in DexSort.values)
          PopupMenuItem(value: option, child: Text(option.label(l10n))),
      ],
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppPalette.of(context).cardSurface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppPalette.of(context).ink, width: 2.5),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTouchTarget,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sort_rounded, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(sort.label(l10n), style: theme.textTheme.labelLarge),
                const SizedBox(width: AppSpacing.xs),
                const Icon(Icons.arrow_drop_down_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
