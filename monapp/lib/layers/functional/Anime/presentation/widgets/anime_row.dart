import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/anime.dart';
import '../../domain/entities/anime_details.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../../../technical/Theme/widgets/skeleton_bar.dart';

class AnimeRow extends StatelessWidget {
  const AnimeRow({required this.anime, super.key});

  final Anime anime;

  static String _metaLine(AnimeDetails details) =>
      '${details.studio} · ${details.year} · ${details.episodeCount} épisodes';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final details = anime.details;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimePoster(title: anime.title, imageUrl: anime.details?.posterUrl),
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
