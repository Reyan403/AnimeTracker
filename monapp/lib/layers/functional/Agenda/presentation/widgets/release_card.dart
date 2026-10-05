import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/anime_poster.dart';
import '../../domain/entities/scheduled_release.dart';
import '../release_countdown.dart';

class ReleaseCard extends StatelessWidget {
  const ReleaseCard({
    required this.release,
    required this.now,
    required this.onTap,
    super.key,
  });

  final ScheduledRelease release;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat('EEEE d MMMM · HH:mm', locale)
        .format(release.releaseAt.toLocal());

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
                title: release.title,
                imageUrl: release.posterUrl,
                heroTag: AnimePoster.heroTagFor('agenda', release.animeId),
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
                        color: scheme.primary,
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
                      date,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.nextEpisodeToWatch(release.nextEpisodeToWatch),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
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
