import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/widgets/state_message.dart';
import '../cubit/dex_state.dart';
import 'booster_launcher.dart';

class DexEmptyCollection extends StatelessWidget {
  const DexEmptyCollection({required this.state, super.key});

  final DexState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canOpen = state.isBoosterAvailable;

    return StateMessage(
      icon: Icons.auto_awesome,
      title: l10n.dexEmptyTitle,
      description: canOpen ? l10n.dexEmptyHint : l10n.dexEmptyWaitHint,
      actionLabel: canOpen ? l10n.dexOpenFirstBooster : null,
      onAction: canOpen ? () => BoosterLauncher.open(context) : null,
    );
  }
}
