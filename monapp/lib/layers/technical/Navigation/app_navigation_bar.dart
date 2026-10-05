import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../Theme/app_palette.dart';
import '../Theme/widgets/bouncy_icon.dart';
import 'app_destination.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final AppDestination selected;
  final ValueChanged<AppDestination> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: palette.ink, width: 3)),
      ),
      child: NavigationBar(
        selectedIndex: selected.index,
        onDestinationSelected: (index) =>
            onSelected(AppDestination.values[index]),
        destinations: [
          for (final destination in AppDestination.values)
            NavigationDestination(
              icon: BouncyIcon(icon: destination.icon, isSelected: false),
              selectedIcon: BouncyIcon(
                icon: destination.selectedIcon,
                isSelected: true,
              ),
              label: destination.labelOf(l10n),
            ),
        ],
      ),
    );
  }
}
