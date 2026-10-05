import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_motion.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/anime.dart';

class EpisodeProgress extends StatelessWidget {
  const EpisodeProgress({
    required this.anime,
    required this.onNext,
    required this.onPrevious,
    super.key,
  });

  final Anime anime;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final total = anime.totalEpisodes;
    final label = total > 0
        ? l10n.episodeProgress(anime.episodesWatched, total)
        : l10n.episodeProgressOpen(anime.episodesWatched);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (anime.progress != null)
                TweenAnimationBuilder<double>(
                  tween: Tween(end: anime.progress),
                  duration: AppMotion.resolve(context, AppMotion.standard),
                  curve: AppMotion.curve,
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: anime.episodesWatched > 0 ? onPrevious : null,
          tooltip: l10n.watchPreviousTooltip,
          icon: const Icon(Icons.remove),
        ),
        IconButton.filledTonal(
          onPressed: anime.isFinished ? null : onNext,
          tooltip: l10n.watchNextTooltip,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
