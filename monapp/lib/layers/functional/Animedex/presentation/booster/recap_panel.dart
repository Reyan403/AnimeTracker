import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../cubit/booster_state.dart';

class RecapPanel extends StatelessWidget {
  const RecapPanel({required this.state, required this.onDone, super.key});

  final BoosterState state;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.dexRecapTitle,
          style: theme.textTheme.titleLarge?.copyWith(color: palette.sun),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${l10n.dexRecapNew(state.newCount)} · '
          '${l10n.dexRecapDuplicates(state.duplicateCount)}',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: palette.starGlow),
        ),
        const SizedBox(height: AppSpacing.md),
        FilledButton.icon(
          onPressed: onDone,
          icon: const Icon(Icons.collections_bookmark_outlined),
          label: Text(l10n.dexSeeCards),
        ),
      ],
    );
  }
}
