import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_motion.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../Anime/domain/entities/watch_status.dart';
import '../../../Anime/presentation/watch_status_display.dart';
import '../../domain/entities/watch_stats.dart';

class StatusBreakdown extends StatelessWidget {
  const StatusBreakdown({required this.stats, super.key});

  final WatchStats stats;

  int _countOf(WatchStatus status) => switch (status) {
        WatchStatus.toWatch => stats.toWatchCount,
        WatchStatus.watching => stats.watchingCount,
        WatchStatus.completed => stats.completedCount,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.statsBreakdownTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: SizedBox(
                height: 14,
                child: Row(
                  children: [
                    for (final status in WatchStatus.values)
                      if (_countOf(status) > 0)
                        Expanded(
                          flex: _countOf(status),
                          child: AnimatedContainer(
                            duration:
                                AppMotion.resolve(context, AppMotion.standard),
                            color: status.colorOf(palette),
                          ),
                        ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: [
                for (final status in WatchStatus.values)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: status.colorOf(palette),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${status.labelOf(l10n)} · ${_countOf(status)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
