import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/anime.dart';
import '../../domain/entities/anime_details.dart';
import '../../../../technical/Theme/widgets/anime_plaque.dart';

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
          AnimePlaque(title: anime.title),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(anime.title, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
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
