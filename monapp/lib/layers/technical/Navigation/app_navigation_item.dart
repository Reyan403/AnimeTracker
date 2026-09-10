import 'package:flutter/material.dart';

import '../Theme/app_colors.dart';
import '../Theme/app_spacing.dart';
import 'app_destination.dart';

class AppNavigationItem extends StatelessWidget {
  const AppNavigationItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final AppDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colour = isSelected ? AppColors.accent : AppColors.inkMuted;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(destination.icon, size: 22, color: colour),
            const SizedBox(height: AppSpacing.xs),
            Text(
              destination.label,
              style: theme.textTheme.titleSmall?.copyWith(color: colour),
            ),
          ],
        ),
      ),
    );
  }
}
