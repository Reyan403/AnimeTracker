import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';
import '../../../../technical/Theme/app_spacing.dart';

class AddEpisodeButton extends StatelessWidget {
  const AddEpisodeButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add, size: 16, color: AppColors.ink),
      label: Text('1 épisode', style: Theme.of(context).textTheme.titleSmall),
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.paper,
        side: const BorderSide(
          color: AppColors.rule,
          width: AppSpacing.hairline,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSpacing.squareRadius),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + AppSpacing.xs,
        ),
      ),
    );
  }
}
