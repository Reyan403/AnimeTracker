import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../../Catalogue/domain/entities/catalogue_anime.dart';

class RecommendationTile extends StatelessWidget {
  const RecommendationTile({
    required this.anime,
    required this.onTap,
    required this.onAdd,
    super.key,
  });

  static const double width = 132;
  static const double posterHeight = 188;

  final CatalogueAnime anime;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AnimePoster(
                  title: anime.title,
                  imageUrl: anime.posterUrl,
                  heroTag: AnimePoster.heroTagFor('discover', anime.id),
                  width: width,
                  height: posterHeight,
                ),
                Positioned(
                  right: AppSpacing.xs,
                  bottom: AppSpacing.xs,
                  child: IconButton.filled(
                    onPressed: onAdd,
                    tooltip: l10n.addToWatchTooltip,
                    icon: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              anime.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
