import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);

    return PopupMenuButton<WatchStatus>(
      tooltip: l10n.changeCategoryTooltip,
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final status in WatchStatus.values)
          CheckedPopupMenuItem<WatchStatus>(
            value: status,
            checked: status == selected,
            child: Text(status.labelOf(l10n)),
          ),
      ],
    );
  }
}
