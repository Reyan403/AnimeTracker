import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/anime.dart';

class EpisodeProgress extends StatelessWidget {
  const EpisodeProgress({required this.anime, super.key});

  final Anime anime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: anime.progress,
            minHeight: AppSpacing.ruleThickness,
            backgroundColor: AppColors.rule,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          '${anime.watchedEpisodes} / ${anime.episodeCount}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
