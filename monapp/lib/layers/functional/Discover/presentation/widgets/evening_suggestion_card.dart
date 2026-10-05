import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/anime_meta_line.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../../Anime/presentation/anime_genre_label.dart';
import '../../domain/entities/evening_suggestion.dart';

class EveningSuggestionCard extends StatelessWidget {
  const EveningSuggestionCard({
    required this.suggestion,
    required this.onOpen,
    required this.onAnother,
    required this.onAdd,
    super.key,
  });

  static const int maxGenres = 3;

  final EveningSuggestion suggestion;
  final VoidCallback onOpen;
  final VoidCallback onAnother;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final anime = suggestion.anime;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimePoster(
          title: anime.title,
          imageUrl: anime.posterUrl,
          heroTag: AnimePoster.heroTagFor('discover', anime.id),
          width: 110,
          height: 156,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(anime.title, style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                animeMetaLine(
                  l10n,
                  format: anime.format,
                  year: anime.year,
                  episodeCount: anime.episodeCount,
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                suggestion.isListed
                    ? l10n.eveningAlreadyListed
                    : l10n.eveningFromCatalogue,
                style: theme.textTheme.bodyMedium,
              ),
              if (suggestion.genres.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  children: [
                    for (final genre in suggestion.genres.take(maxGenres))
                      Chip(label: Text(genreLabel(l10n, genre))),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  FilledButton(
                    onPressed: onOpen,
                    child: Text(l10n.eveningOpenSheet),
                  ),
                  if (!suggestion.isListed)
                    FilledButton.tonal(
                      onPressed: onAdd,
                      child: Text(l10n.eveningAddToList),
                    ),
                  OutlinedButton(
                    onPressed: onAnother,
                    child: Text(l10n.eveningAnother),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
