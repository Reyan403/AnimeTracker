import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../../../technical/Theme/widgets/genre_tag.dart';
import '../../domain/entities/anime_extras.dart';

class RelatedAnimeTile extends StatelessWidget {
  const RelatedAnimeTile({
    required this.related,
    required this.onTap,
    super.key,
  });

  static const double width = 112;
  static const double posterHeight = 158;

  final RelatedAnime related;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final anime = related.anime;

    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimePoster(
              title: anime.title,
              imageUrl: anime.posterUrl,
              width: width,
              height: posterHeight,
            ),
            const SizedBox(height: AppSpacing.sm),
            GenreTag(
              label: related.role == RelationRole.sequel
                  ? l10n.relationSequel
                  : l10n.relationPrequel,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              anime.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
