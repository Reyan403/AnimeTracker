import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/watch_status.dart';
import '../cubit/watchlist_state.dart';
import '../watch_status_display.dart';

class WatchlistHeader extends StatelessWidget {
  const WatchlistHeader({required this.state, super.key});

  final WatchlistState state;

  String get _summary => [
        '${state.countOf(WatchStatus.watching)} '
            '${WatchStatus.watching.countLabel}',
        '${state.countOf(WatchStatus.toWatch)} '
            '${WatchStatus.toWatch.countLabel}',
        '${state.countOf(WatchStatus.completed)} '
            '${WatchStatus.completed.countLabel}',
      ].join(' · ');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ma liste', style: theme.textTheme.displaySmall),
        if (state.animes.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(_summary, style: theme.textTheme.bodyMedium),
        ],
      ],
    );
  }
}
