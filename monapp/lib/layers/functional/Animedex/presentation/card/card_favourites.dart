import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import 'favourites_format.dart';

class CardFavourites extends StatelessWidget {
  const CardFavourites({required this.count, this.compact = false, super.key});

  final int count;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.nebula.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_rounded,
              size: compact ? 12 : 14,
              color: palette.candy,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              FavouritesFormat.of(l10n, count),
              style: theme.textTheme.labelMedium?.copyWith(
                color: palette.starGlow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
