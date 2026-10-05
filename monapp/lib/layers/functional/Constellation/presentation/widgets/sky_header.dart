import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';

class SkyHeader extends StatelessWidget {
  const SkyHeader({required this.onBack, super.key});

  static const double height = AppSpacing.minTouchTarget + AppSpacing.md;

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            IconButton.filled(
              tooltip: l10n.constellationBack,
              style: IconButton.styleFrom(
                backgroundColor: palette.nebula.withValues(alpha: 0.75),
                foregroundColor: palette.starGlow,
                side: BorderSide(color: palette.starGlow, width: 1.5),
                minimumSize: const Size.square(AppSpacing.minTouchTarget),
              ),
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                l10n.constellationTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.displaySmall?.copyWith(
                  color: palette.starGlow,
                  shadows: [
                    Shadow(color: palette.candy, offset: const Offset(3, 3)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
