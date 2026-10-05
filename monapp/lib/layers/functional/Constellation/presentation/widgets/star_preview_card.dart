import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../../../technical/Theme/widgets/genre_tag.dart';
import '../../../../technical/Theme/widgets/pop_card.dart';
import '../../../Discover/domain/entities/evening_mood.dart';
import '../../../Discover/presentation/evening_labels.dart';
import '../../../Anime/presentation/watch_status_display.dart';
import '../../domain/entities/constellation_star.dart';

class StarPreviewCard extends StatelessWidget {
  const StarPreviewCard({
    required this.star,
    required this.linkCount,
    required this.onOpen,
    required this.onClose,
    this.genre,
    super.key,
  });

  static const double posterWidth = 72;
  static const double posterHeight = 104;

  final ConstellationStar star;
  final EveningMood? genre;
  final int linkCount;
  final VoidCallback onOpen;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final tag = genre;

    return PopCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimePoster(
              title: star.title,
              imageUrl: star.posterUrl,
              width: posterWidth,
              height: posterHeight,
              heroTag: AnimePoster.heroTagFor('constellation', star.animeId),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          star.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.constellationClosePreview,
                        visualDensity: VisualDensity.compact,
                        onPressed: onClose,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  Text(
                    star.status.labelOf(l10n),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: star.status.colorOf(palette),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (tag != null) GenreTag(label: tag.labelOf(l10n)),
                      Text(
                        l10n.constellationLinkedCount(linkCount),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton(
                    onPressed: onOpen,
                    child: Text(l10n.constellationOpenSheet),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
