import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_motion.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';

class DexFilterChip extends StatelessWidget {
  const DexFilterChip({
    required this.label,
    required this.tone,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.icon = Icons.star_rounded,
    super.key,
  });

  final String label;
  final Color tone;
  final int count;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);
    final ink = ThemeData.estimateBrightnessForColor(tone) == Brightness.dark
        ? palette.starGlow
        : palette.nebula;
    final textColor = isSelected ? ink : theme.colorScheme.onSurface;
    final radius = BorderRadius.circular(AppSpacing.radiusLg);
    final duration = AppMotion.resolve(context, AppMotion.standard);

    return Semantics(
      button: true,
      selected: isSelected,
      child: AnimatedScale(
        scale: isSelected ? 1.06 : 1,
        duration: duration,
        curve: Curves.easeOutBack,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: AnimatedContainer(
              duration: AppMotion.resolve(context, AppMotion.fast),
              constraints: const BoxConstraints(
                minHeight: AppSpacing.minTouchTarget,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected ? tone : palette.cardSurface,
                borderRadius: radius,
                border: Border.all(color: tone, width: 2.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 18, color: isSelected ? ink : tone),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '$count',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: textColor.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
