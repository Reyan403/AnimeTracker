import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/anime.dart';
import '../../domain/entities/watch_status.dart';
import '../watch_status_display.dart';

const List<String> _weekdays = [
  'LUN.',
  'MAR.',
  'MER.',
  'JEU.',
  'VEN.',
  'SAM.',
  'DIM.',
];

const List<String> _months = [
  'JANV.',
  'FÉVR.',
  'MARS',
  'AVR.',
  'MAI',
  'JUIN',
  'JUIL.',
  'AOÛT',
  'SEPT.',
  'OCT.',
  'NOV.',
  'DÉC.',
];

String formatIssueDate(DateTime date) =>
    '${_weekdays[date.weekday - 1]} ${date.day} '
    '${_months[date.month - 1]} ${date.year}';

class WatchlistHeader extends StatelessWidget {
  const WatchlistHeader({
    required this.animes,
    required this.issueDate,
    super.key,
  });

  final List<Anime> animes;
  final DateTime issueDate;

  int _countOf(WatchStatus status) =>
      animes.where((anime) => anime.status == status).length;

  String get _summary => [
        '${_countOf(WatchStatus.watching)} ${WatchStatus.watching.countLabel}',
        '${_countOf(WatchStatus.toWatch)} ${WatchStatus.toWatch.countLabel}',
        '${_countOf(WatchStatus.completed)} '
            '${WatchStatus.completed.countLabel}',
      ].join(' · ');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SAISON',
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: AppColors.accent),
            ),
            Text(formatIssueDate(issueDate), style: theme.textTheme.labelSmall),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Ma liste', style: theme.textTheme.displaySmall),
        const SizedBox(height: AppSpacing.sm),
        Text(_summary, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
