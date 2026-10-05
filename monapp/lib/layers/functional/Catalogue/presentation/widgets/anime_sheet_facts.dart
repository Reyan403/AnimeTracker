import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/anime_sheet.dart';

class AnimeSheetFacts extends StatelessWidget {
  const AnimeSheetFacts({required this.sheet, super.key});

  final AnimeSheet sheet;

  static String grouped(int count) {
    final digits = count.toString();
    final buffer = StringBuffer();

    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) {
        buffer.write(' ');
      }

      buffer.write(digits[index]);
    }

    return buffer.toString();
  }

  static String? _broadcast(AnimeSheet sheet) {
    final start = sheet.startYear;

    if (start == null) {
      return null;
    }

    final end = sheet.endYear;

    return end == null || end == start ? '$start' : '$start – $end';
  }

  static String? _episodes(AppLocalizations l10n, AnimeSheet sheet) {
    final count = sheet.episodeCount;
    final minutes = sheet.episodeMinutes;

    if (count == null) {
      return minutes == null ? null : l10n.minutesPerEpisode(minutes);
    }

    return minutes == null
        ? l10n.episodesCount(count)
        : l10n.episodesOfMinutes(count, minutes);
  }

  static String? _watchTime(AppLocalizations l10n, AnimeSheet sheet) {
    final minutes = sheet.totalMinutes;

    return minutes == null || minutes < 60
        ? null
        : l10n.hoursTotal(minutes ~/ 60);
  }

  Map<String, String> _facts(AppLocalizations l10n) => {
        l10n.factFormat: sheet.format,
        if (sheet.status != null) l10n.factStatus: sheet.status!,
        if (_broadcast(sheet) != null) l10n.factBroadcast: _broadcast(sheet)!,
        if (_episodes(l10n, sheet) != null)
          l10n.factEpisodes: _episodes(l10n, sheet)!,
        if (_watchTime(l10n, sheet) != null)
          l10n.factTotalDuration: _watchTime(l10n, sheet)!,
        if (sheet.rating != null)
          l10n.factRating: l10n.ratingPercent(sheet.rating!),
        if (sheet.ratingRank != null)
          l10n.factRatingRank: l10n.rankOrdinal(sheet.ratingRank!),
        if (sheet.popularityRank != null)
          l10n.factPopularity: l10n.rankOrdinal(sheet.popularityRank!),
        if (sheet.memberCount != null)
          l10n.factMembers: grouped(sheet.memberCount!),
        if (sheet.favoriteCount != null)
          l10n.factFavorites: grouped(sheet.favoriteCount!),
        if (sheet.ageRating != null) l10n.factAudience: sheet.ageRating!,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final facts = _facts(AppLocalizations.of(context));

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          children: [
            for (final fact in facts.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        fact.key,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        fact.value,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
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
