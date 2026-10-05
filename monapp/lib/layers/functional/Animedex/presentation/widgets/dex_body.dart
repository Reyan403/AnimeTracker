import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/widgets/state_message.dart';
import '../../domain/entities/dex_card.dart';
import '../cubit/dex_state.dart';
import 'dex_grid.dart';
import 'dex_skeleton_grid.dart';

class DexBody extends StatelessWidget {
  const DexBody({
    required this.state,
    required this.onCardTap,
    required this.onRetry,
    required this.onOpenBooster,
    super.key,
  });

  final DexState state;
  final ValueChanged<DexCard> onCardTap;
  final VoidCallback onRetry;
  final VoidCallback onOpenBooster;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return switch (state.status) {
      DexStatus.loading => const DexSkeletonGrid(),
      DexStatus.success => DexGrid(cards: state.cards, onCardTap: onCardTap),
      DexStatus.empty => SliverToBoxAdapter(
        child: StateMessage(
          icon: Icons.auto_awesome,
          title: l10n.dexEmptyTitle,
          description: state.isBoosterAvailable
              ? l10n.dexEmptyHint
              : l10n.dexEmptyWaitHint,
          actionLabel: state.isBoosterAvailable
              ? l10n.dexOpenFirstBooster
              : null,
          onAction: state.isBoosterAvailable ? onOpenBooster : null,
        ),
      ),
      DexStatus.failure => SliverToBoxAdapter(
        child: StateMessage(
          icon: Icons.cloud_off_outlined,
          title: l10n.dexErrorTitle,
          description: l10n.dexErrorHint,
          actionLabel: l10n.retry,
          onAction: onRetry,
        ),
      ),
    };
  }
}
