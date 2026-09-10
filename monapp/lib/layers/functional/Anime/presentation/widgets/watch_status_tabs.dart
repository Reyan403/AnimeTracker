import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/anime.dart';
import '../../domain/entities/watch_status.dart';
import '../watch_status_display.dart';
import 'watch_status_tab.dart';

class WatchStatusTabs extends StatelessWidget {
  const WatchStatusTabs({
    required this.animes,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<Anime> animes;
  final WatchStatus selected;
  final ValueChanged<WatchStatus> onSelected;

  int _countOf(WatchStatus status) =>
      animes.where((anime) => anime.status == status).length;

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
                count: _countOf(status),
                isSelected: status == selected,
                onTap: () => onSelected(status),
              ),
            ),
        ],
      ),
    );
  }
}
