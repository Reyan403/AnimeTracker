import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/pop_card.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../../../technical/Theme/widgets/genre_tag.dart';
import '../../domain/entities/scheduled_release.dart';
import '../release_countdown.dart';

class ReleaseCard extends StatelessWidget {
  const ReleaseCard({
    required this.release,
    required this.now,
    this.onTap,
    super.key,
  });

  final ScheduledRelease release;
  final DateTime now;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat(
      'EEEE d MMMM · HH:mm',
      locale,
    ).format(release.releaseAt.toLocal());
    final animeId = release.animeId;
    final episode = release.episode;

    return PopCard(
      clipBehavior: Clip.antiAlias,
      isInteractive: onTap != null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimePoster(
                title: release.title,
                imageUrl: release.posterUrl,
                heroTag: animeId == null
                    ? null
                    : AnimePoster.heroTagFor('agenda', animeId),
                width: 64,
                height: 92,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      releaseCountdown(l10n, release, now),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppPalette.of(context).accentText,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      release.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      [
                        if (episode != null) l10n.releaseEpisode(episode),
                        date,
                      ].join(' · '),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    if (release.isInWatchlist) ...[
                      const SizedBox(height: AppSpacing.sm),
                      GenreTag(
                        label: l10n.inWatchlistBadge,
                        icon: Icons.bookmark,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
