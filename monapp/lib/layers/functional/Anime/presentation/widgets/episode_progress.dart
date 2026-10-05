import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/widgets/pop_progress_bar.dart';
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

    final progress = anime.progress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: progress == null
                  ? const SizedBox.shrink()
                  : PopProgressBar(value: progress),
            ),
            const SizedBox(width: AppSpacing.sm),
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
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
