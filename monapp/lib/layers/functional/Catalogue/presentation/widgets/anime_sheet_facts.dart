import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';
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

  static String? _episodes(AnimeSheet sheet) {
    final count = sheet.episodeCount;
    final minutes = sheet.episodeMinutes;

    if (count == null) {
      return minutes == null ? null : '$minutes min par épisode';
    }

    return minutes == null
        ? '${grouped(count)} épisodes'
        : '${grouped(count)} épisodes de $minutes min';
  }

  static String? _watchTime(AnimeSheet sheet) {
    final minutes = sheet.totalMinutes;

    return minutes == null || minutes < 60 ? null : '${minutes ~/ 60} h';
  }

  Map<String, String> get _facts => {
        'Format': sheet.format,
        if (sheet.status != null) 'Statut': sheet.status!,
        if (_broadcast(sheet) != null) 'Diffusion': _broadcast(sheet)!,
        if (_episodes(sheet) != null) 'Épisodes': _episodes(sheet)!,
        if (_watchTime(sheet) != null) 'Durée totale': _watchTime(sheet)!,
        if (sheet.rating != null) 'Note moyenne': '${sheet.rating} %',
        if (sheet.ratingRank != null) 'Classement': '${sheet.ratingRank}e',
        if (sheet.popularityRank != null)
          'Popularité': '${sheet.popularityRank}e',
        if (sheet.memberCount != null) 'Membres': grouped(sheet.memberCount!),
        if (sheet.favoriteCount != null)
          'Favoris': grouped(sheet.favoriteCount!),
        if (sheet.ageRating != null) 'Public': sheet.ageRating!,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        for (final fact in _facts.entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    fact.key,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: AppColors.inkMuted),
                  ),
                ),
                Expanded(
                  child: Text(fact.value, style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
