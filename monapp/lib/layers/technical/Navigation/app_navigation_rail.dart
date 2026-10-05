import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import 'app_destination.dart';

class AppNavigationRail extends StatelessWidget {
  const AppNavigationRail({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final AppDestination selected;
  final ValueChanged<AppDestination> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return NavigationRail(
      selectedIndex: selected.index,
      onDestinationSelected: (index) => onSelected(AppDestination.values[index]),
      destinations: [
        for (final destination in AppDestination.values)
          NavigationRailDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon),
            label: Text(destination.labelOf(l10n)),
          ),
      ],
    );
  }
}
