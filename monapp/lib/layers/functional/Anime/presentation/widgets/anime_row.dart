import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/anime.dart';
import 'add_episode_button.dart';
import 'anime_plaque.dart';
import 'episode_progress.dart';

class AnimeRow extends StatelessWidget {
  const AnimeRow({required this.anime, super.key});

  final Anime anime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimePlaque(title: anime.title),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(anime.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      anime.originalTitle,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${anime.studio} · ${anime.year} · ${anime.episodeCount} épisodes',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    EpisodeProgress(anime: anime),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.plaqueWidth + AppSpacing.md,
            ),
            child: AddEpisodeButton(onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
