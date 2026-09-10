import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/anime.dart';
import '../../domain/entities/watch_status.dart';
import '../watch_status_display.dart';

class WatchlistHeader extends StatelessWidget {
  const WatchlistHeader({required this.animes, super.key});

  final List<Anime> animes;

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
        Text('Ma liste', style: theme.textTheme.displaySmall),
        const SizedBox(height: AppSpacing.sm),
        Text(_summary, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
