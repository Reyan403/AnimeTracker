import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';
import '../../domain/entities/watch_status.dart';
import '../watch_status_display.dart';

class WatchStatusMenu extends StatelessWidget {
  const WatchStatusMenu({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final WatchStatus selected;
  final ValueChanged<WatchStatus> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<WatchStatus>(
      tooltip: 'Changer de catégorie',
      icon: const Icon(Icons.more_vert, color: AppColors.inkMuted),
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final status in WatchStatus.values)
          CheckedPopupMenuItem<WatchStatus>(
            value: status,
            checked: status == selected,
            child: Text(status.tabLabel),
          ),
      ],
    );
  }
}
