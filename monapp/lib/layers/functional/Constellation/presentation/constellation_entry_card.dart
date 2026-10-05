import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../technical/Theme/app_palette.dart';
import '../../../technical/Theme/app_spacing.dart';
import '../../../technical/Theme/widgets/pop_card.dart';
import 'constellation_page.dart';
import 'widgets/mini_sky.dart';

class ConstellationEntryCard extends StatelessWidget {
  const ConstellationEntryCard({super.key});

  static const double previewWidth = 104;
  static const double previewHeight = 84;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    return PopCard(
      isInteractive: true,
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        button: true,
        label: l10n.constellationTitle,
        excludeSemantics: true,
        child: InkWell(
          onTap: () => ConstellationPage.open(context),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          palette.nebula,
                          Color.lerp(palette.nebula, palette.rarityEpic, 0.35)!,
                        ],
                      ),
                    ),
                    child: const SizedBox(
                      width: previewWidth,
                      height: previewHeight,
                      child: MiniSky(),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.constellationTitle,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.constellationEntrySubtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
