import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_motion.dart';
import '../../../../technical/Theme/app_spacing.dart';
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

    return Card(
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
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(end: share.count / maximum),
                        duration: AppMotion.resolve(
                          context,
                          const Duration(milliseconds: 600),
                        ),
                        curve: AppMotion.curve,
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          minHeight: 10,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
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
