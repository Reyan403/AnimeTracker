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
    super.key,
  });

  final EveningSuggestion suggestion;
  final VoidCallback onOpen;
  final VoidCallback onAnother;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final anime = suggestion.anime;
    final details = anime.details;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimePoster(
          title: anime.title,
          imageUrl: details?.posterUrl,
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
              if (details != null)
                Text(
                  animeMetaLine(
                    l10n,
                    format: details.format,
                    year: details.year,
                    episodeCount: details.episodeCount,
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                suggestion.isContinuing
                    ? l10n.eveningContinuing
                    : l10n.eveningFromList,
                style: theme.textTheme.bodyMedium,
              ),
              if (suggestion.matchedGenres.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  children: [
                    for (final genre in suggestion.matchedGenres)
                      Chip(label: Text(genreLabel(l10n, genre))),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  FilledButton(
                    onPressed: onOpen,
                    child: Text(l10n.eveningOpenSheet),
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
