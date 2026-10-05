import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';
import '../cubit/booster_state.dart';
import 'tray_card.dart';

class RevealTray extends StatelessWidget {
  const RevealTray({required this.state, super.key});

  static const double maxSlotWidth = 64;

  final BoosterState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var index = 0; index < state.cards.length; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxSlotWidth),
              child: TrayCard(
                drawn: index < state.revealedCount ? state.cards[index] : null,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
