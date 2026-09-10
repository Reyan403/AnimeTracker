import 'package:flutter/material.dart';

import '../Theme/app_colors.dart';
import '../Theme/app_spacing.dart';
import 'app_destination.dart';
import 'app_navigation_item.dart';

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
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.paper,
        border: Border(
          top: BorderSide(
            color: AppColors.rule,
            width: AppSpacing.hairline,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (final destination in AppDestination.values)
              Expanded(
                child: AppNavigationItem(
                  destination: destination,
                  isSelected: destination == selected,
                  onTap: () => onSelected(destination),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
