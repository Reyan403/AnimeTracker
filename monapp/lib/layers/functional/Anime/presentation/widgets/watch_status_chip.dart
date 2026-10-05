import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_motion.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/watch_status.dart';
import '../watch_status_display.dart';

class WatchStatusChip extends StatelessWidget {
  const WatchStatusChip({required this.status, super.key});

  final WatchStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.colorOf(AppPalette.of(context));
    final label = status.labelOf(AppLocalizations.of(context));

    return AnimatedContainer(
      duration: AppMotion.resolve(context, AppMotion.standard),
      curve: AppMotion.curve,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: AnimatedSwitcher(
        duration: AppMotion.resolve(context, AppMotion.fast),
        child: Text(
          label,
          key: ValueKey(status),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
