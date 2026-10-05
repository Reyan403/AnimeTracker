import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/watch_status.dart';
import '../cubit/watchlist_state.dart';
import '../watch_status_display.dart';
import 'watch_status_tab.dart';

class WatchStatusTabs extends StatelessWidget {
  const WatchStatusTabs({
    required this.state,
    required this.onSelected,
    super.key,
  });

  final WatchlistState state;
  final ValueChanged<WatchStatus> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Row(
          children: [
            for (final status in WatchStatus.values)
              Expanded(
                child: WatchStatusTab(
                  label: status.labelOf(l10n),
                  count: state.countOf(status),
                  isSelected: status == state.selected,
                  onTap: () => onSelected(status),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
