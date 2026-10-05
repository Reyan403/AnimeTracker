import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/plaque_row_skeleton.dart';
import '../../../../technical/Theme/widgets/state_message.dart';
import '../cubit/stats_state.dart';
import 'genre_bars.dart';
import 'stat_tile.dart';

class StatsContent extends StatelessWidget {
  const StatsContent({required this.state, required this.onRetry, super.key});

  final StatsState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stats = state.stats;

    return switch (state.status) {
      StatsStatus.loading => const PlaqueRowSkeleton(rowCount: 2),
      StatsStatus.empty => StateMessage(
          icon: Icons.insights_outlined,
          title: l10n.statsEmpty,
          description: l10n.statsEmptyHint,
        ),
      StatsStatus.failure => StateMessage(
          icon: Icons.cloud_off_outlined,
          title: l10n.statsErrorTitle,
          description: l10n.serviceUnavailable,
          actionLabel: l10n.retry,
          onAction: onRetry,
        ),
      StatsStatus.success => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    value: stats!.episodesWatched,
                    label: l10n.statsEpisodes,
                    icon: Icons.play_circle_outline,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StatTile(
                    value: stats.completedCount,
                    label: l10n.statsCompleted,
                    icon: Icons.check_circle_outline,
                  ),
                ),
              ],
            ),
            if (stats.topGenres.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              GenreBars(genres: stats.topGenres),
            ],
          ],
        ),
    };
  }
}
