import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../../../technical/Theme/widgets/skeleton_bar.dart';
import '../../domain/entities/anime.dart';
import '../../domain/entities/anime_details.dart';

class AnimeRow extends StatelessWidget {
  const AnimeRow({required this.anime, super.key});

  final Anime anime;

  static String _metaLine(AnimeDetails details) => [
        details.format,
        if (details.year > 0) '${details.year}',
        if (details.episodeCount > 0) '${details.episodeCount} épisodes',
      ].join(' · ');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final details = anime.details;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimePoster(title: anime.title, imageUrl: details?.posterUrl),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(anime.title, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                if (anime.isLoadingDetails)
                  const SkeletonBar(widthFactor: 0.5, height: 14)
                else
                  Text(
                    details == null ? 'Fiche indisponible' : _metaLine(details),
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
