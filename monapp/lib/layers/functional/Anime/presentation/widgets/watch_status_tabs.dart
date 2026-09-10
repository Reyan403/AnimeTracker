import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';
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
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.rule,
          width: AppSpacing.hairline,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.squareRadius),
        color: AppColors.paper,
      ),
      child: Row(
        children: [
          for (final status in WatchStatus.values)
            Expanded(
              child: WatchStatusTab(
                label: status.tabLabel,
                count: state.countOf(status),
                isSelected: status == state.selected,
                onTap: () => onSelected(status),
              ),
            ),
        ],
      ),
    );
  }
}
