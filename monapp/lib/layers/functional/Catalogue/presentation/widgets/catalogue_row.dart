import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../domain/entities/catalogue_anime.dart';

class CatalogueRow extends StatelessWidget {
  const CatalogueRow({
    required this.anime,
    required this.isListed,
    required this.onAdd,
    super.key,
  });

  final CatalogueAnime anime;
  final bool isListed;
  final VoidCallback onAdd;

  static String _metaLine(CatalogueAnime anime) => [
        anime.format,
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
          AnimePoster(title: anime.title, imageUrl: anime.posterUrl),
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
          IconButton(
            onPressed: isListed ? null : onAdd,
            tooltip: isListed ? 'Déjà dans ma liste' : 'Ajouter à « À voir »',
            color: AppColors.accent,
            disabledColor: AppColors.inkMuted,
            icon: Icon(isListed ? Icons.check : Icons.add),
          ),
        ],
      ),
    );
  }
}
