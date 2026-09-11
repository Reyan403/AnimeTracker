import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/anime_plaque.dart';
import '../../domain/entities/catalogue_anime.dart';

class CatalogueRow extends StatelessWidget {
  const CatalogueRow({required this.anime, super.key});

  final CatalogueAnime anime;

  static String _metaLine(CatalogueAnime anime) => [
        anime.studio,
        if (anime.year > 0) '${anime.year}',
        if (anime.episodeCount > 0) '${anime.episodeCount} épisodes',
      ].join(' · ');

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
                const SizedBox(height: AppSpacing.sm),
                Text(_metaLine(anime), style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
