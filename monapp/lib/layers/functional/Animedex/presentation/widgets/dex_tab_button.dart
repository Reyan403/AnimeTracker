import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_motion.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';

class DexTabButton extends StatelessWidget {
  const DexTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.count,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = isSelected ? scheme.onPrimary : scheme.onSurface;
    final total = count;

    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: AnimatedContainer(
          duration: AppMotion.resolve(context, AppMotion.standard),
          curve: AppMotion.curve,
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTouchTarget,
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected ? scheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: isSelected
                  ? AppPalette.of(context).ink
                  : Colors.transparent,
              width: 2.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: foreground,
                  ),
                ),
              ),
              if (total != null) ...[
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '$total',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: foreground.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
