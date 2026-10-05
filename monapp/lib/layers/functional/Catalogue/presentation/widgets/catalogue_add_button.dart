import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_motion.dart';
import '../../../../technical/Theme/app_spacing.dart';

class CatalogueAddButton extends StatelessWidget {
  const CatalogueAddButton({
    required this.isListed,
    required this.onAdd,
    super.key,
  });

  final bool isListed;
  final VoidCallback onAdd;

  Widget _scaled(Widget child, Animation<double> animation) =>
      ScaleTransition(scale: animation, child: child);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return IconButton.filledTonal(
      onPressed: isListed ? null : onAdd,
      tooltip: isListed ? l10n.alreadyListedTooltip : l10n.addToWatchTooltip,
      constraints: const BoxConstraints(
        minWidth: AppSpacing.minTouchTarget,
        minHeight: AppSpacing.minTouchTarget,
      ),
      icon: AnimatedSwitcher(
        duration: AppMotion.resolve(context, AppMotion.standard),
        switchInCurve: Curves.easeOutBack,
        transitionBuilder: _scaled,
        child: Icon(
          isListed ? Icons.check : Icons.add,
          key: ValueKey(isListed),
        ),
      ),
    );
  }
}
