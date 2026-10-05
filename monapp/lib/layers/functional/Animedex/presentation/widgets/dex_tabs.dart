import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../cubit/dex_state.dart';
import 'dex_tab_button.dart';

class DexTabs extends StatelessWidget {
  const DexTabs({
    required this.selected,
    required this.collectionCount,
    required this.onSelected,
    super.key,
  });

  final DexTab selected;
  final int collectionCount;
  final ValueChanged<DexTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: palette.ink, width: 2.5),
        boxShadow: [
          BoxShadow(color: palette.hardShadow, offset: const Offset(4, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Row(
          children: [
            Expanded(
              child: DexTabButton(
                label: l10n.dexTabBooster,
                isSelected: selected == DexTab.booster,
                onTap: () => onSelected(DexTab.booster),
              ),
            ),
            Expanded(
              child: DexTabButton(
                label: l10n.dexTabCollection,
                count: collectionCount,
                isSelected: selected == DexTab.collection,
                onTap: () => onSelected(DexTab.collection),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
