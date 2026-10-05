import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/widgets/pop_progress_bar.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/pop_card.dart';
import '../../../Anime/presentation/anime_genre_label.dart';
import '../../domain/entities/watch_stats.dart';

class GenreBars extends StatelessWidget {
  const GenreBars({required this.genres, super.key});

  final List<GenreShare> genres;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final maximum = genres.isEmpty ? 1 : genres.first.count;

    return PopCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.statsGenresTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            for (final share in genres)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    SizedBox(
                      width: 112,
                      child: Text(
                        genreLabel(l10n, share.genre),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      child: PopProgressBar(
                        value: share.count / maximum,
                        height: 14,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text('${share.count}', style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
