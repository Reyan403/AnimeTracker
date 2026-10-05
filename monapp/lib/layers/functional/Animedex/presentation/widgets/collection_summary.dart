import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/card_rarity.dart';
import '../cubit/dex_state.dart';
import 'rarity_count_chip.dart';

class CollectionSummary extends StatelessWidget {
  const CollectionSummary({required this.state, super.key});

  final DexState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dexCardCount(state.cards.length),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final rarity in CardRarity.values.reversed)
              RarityCountChip(rarity: rarity, count: state.countOf(rarity)),
          ],
        ),
      ],
    );
  }
}
