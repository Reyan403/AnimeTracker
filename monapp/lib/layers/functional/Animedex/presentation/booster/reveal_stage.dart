import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../card/rarity_style.dart';
import '../cubit/booster_state.dart';
import 'rarity_burst.dart';
import 'recap_panel.dart';
import 'reveal_card.dart';
import 'reveal_tray.dart';

class RevealStage extends StatelessWidget {
  const RevealStage({
    required this.state,
    required this.onReveal,
    required this.onDone,
    super.key,
  });

  final BoosterState state;
  final VoidCallback onReveal;
  final VoidCallback onDone;

  void _reveal() {
    if (state.isComplete) {
      return;
    }

    onReveal();
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);
    final current = state.current;
    final rarity = current?.card.rarity;

    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Text(
                l10n.dexRevealProgress(state.revealedCount, state.cards.length),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: palette.starGlow,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: RevealCard(
                  revealedCount: state.revealedCount,
                  current: current,
                  onReveal: _reveal,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              RevealTray(state: state),
              const SizedBox(height: AppSpacing.lg),
              if (state.isComplete)
                RecapPanel(state: state, onDone: onDone)
              else
                Text(
                  l10n.dexRevealHint,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: palette.starGlow,
                  ),
                ),
            ],
          ),
        ),
        if (rarity != null && rarity.isHolographic)
          Positioned.fill(
            child: RarityBurst(
              key: ValueKey(state.revealedCount),
              rarity: rarity,
            ),
          ),
      ],
    );
  }
}
