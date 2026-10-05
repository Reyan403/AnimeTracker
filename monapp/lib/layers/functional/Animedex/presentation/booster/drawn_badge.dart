import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_motion.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';

class DrawnBadge extends StatelessWidget {
  const DrawnBadge({required this.isNew, super.key});

  static const double tilt = 0.12;

  final bool isNew;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final background = isNew ? palette.candy : palette.skeletonBase;
    final label = isNew ? l10n.dexBadgeNew : l10n.dexBadgeDuplicate;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.resolve(context, const Duration(milliseconds: 500)),
      curve: Curves.elasticOut,
      builder: (context, progress, child) => Transform.scale(
        scale: progress,
        child: Transform.rotate(angle: tilt, child: child),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: palette.ink, width: 2.5),
          boxShadow: [
            BoxShadow(color: palette.hardShadow, offset: const Offset(3, 3)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs + 2,
          ),
          child: Text(
            label,
            style: theme.textTheme.titleLarge?.copyWith(
              color: isNew ? palette.posterFallbackInk : palette.ink,
            ),
          ),
        ),
      ),
    );
  }
}
