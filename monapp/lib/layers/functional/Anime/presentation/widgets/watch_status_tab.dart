import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';
import '../../../../technical/Theme/app_spacing.dart';

class WatchStatusTab extends StatelessWidget {
  const WatchStatusTab({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = isSelected ? AppColors.paper : AppColors.ink;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected ? AppColors.accent : AppColors.paper,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(color: foreground),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '$count',
              style: theme.textTheme.bodySmall?.copyWith(
                color: foreground.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
