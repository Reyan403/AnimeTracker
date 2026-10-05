import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_motion.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';

class DexFilterChip extends StatelessWidget {
  const DexFilterChip({
    required this.label,
    required this.tone,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final Color tone;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);
    final ink = ThemeData.estimateBrightnessForColor(tone) == Brightness.dark
        ? palette.starGlow
        : palette.nebula;

    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: AnimatedContainer(
          duration: AppMotion.resolve(context, AppMotion.fast),
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTouchTarget,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected ? tone : palette.cardSurface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: tone, width: 2.5),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isSelected ? ink : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
