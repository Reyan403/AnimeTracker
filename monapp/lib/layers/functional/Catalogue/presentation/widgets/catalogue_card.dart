import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/anime_meta_line.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/pop_card.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../domain/entities/catalogue_anime.dart';
import 'catalogue_add_button.dart';

class CatalogueCard extends StatelessWidget {
  const CatalogueCard({
    required this.anime,
    required this.isListed,
    required this.onTap,
    required this.onAdd,
    super.key,
  });

  final CatalogueAnime anime;
  final bool isListed;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return PopCard(
      clipBehavior: Clip.antiAlias,
      isInteractive: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimePoster(
                title: anime.title,
                imageUrl: anime.posterUrl,
                heroTag: AnimePoster.heroTagFor('catalogue', anime.id),
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
                    Text(
                      animeMetaLine(
                        l10n,
                        format: anime.format,
                        year: anime.year,
                        episodeCount: anime.episodeCount,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              CatalogueAddButton(isListed: isListed, onAdd: onAdd),
            ],
          ),
        ),
      ),
    );
  }
}
