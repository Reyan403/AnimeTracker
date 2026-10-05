import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/anime_meta_line.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../../../technical/Theme/widgets/skeleton_bar.dart';
import '../../domain/entities/anime.dart';
import '../../domain/entities/watch_status.dart';
import 'watch_status_chip.dart';
import 'watch_status_menu.dart';

class AnimeCard extends StatelessWidget {
  const AnimeCard({
    required this.anime,
    required this.onTap,
    required this.onStatusSelected,
    super.key,
  });

  final Anime anime;
  final VoidCallback onTap;
  final ValueChanged<WatchStatus> onStatusSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final details = anime.details;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimePoster(
                title: anime.title,
                imageUrl: details?.posterUrl,
                heroTag: AnimePoster.heroTagFor('list', anime.id),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      anime.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (anime.isLoadingDetails)
                      const SkeletonBar(widthFactor: 0.5, height: 14)
                    else
                      Text(
                        details == null
                            ? l10n.sheetUnavailable
                            : animeMetaLine(
                                l10n,
                                format: details.format,
                                year: details.year,
                                episodeCount: details.episodeCount,
                              ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    WatchStatusChip(status: anime.status),
                  ],
                ),
              ),
              WatchStatusMenu(
                selected: anime.status,
                onSelected: onStatusSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
