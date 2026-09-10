import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/anime.dart';
import 'anime_plaque.dart';

class AnimeRow extends StatelessWidget {
  const AnimeRow({required this.anime, super.key});

  final Anime anime;

  bool get _hasDistinctOriginalTitle => anime.originalTitle != anime.title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimePlaque(title: anime.title),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(anime.title, style: theme.textTheme.titleMedium),
                if (_hasDistinctOriginalTitle) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    anime.originalTitle,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${anime.studio} · ${anime.year} · ${anime.episodeCount} épisodes',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
