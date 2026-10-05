import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/staggered_appear.dart';
import '../../domain/entities/dex_card.dart';
import '../card/card_metrics.dart';
import 'dex_card_tile.dart';

class DexGrid extends StatelessWidget {
  const DexGrid({required this.cards, required this.onCardTap, super.key});

  static const double maxTileWidth = 190;

  final List<DexCard> cards;
  final ValueChanged<DexCard> onCardTap;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxTileWidth,
        childAspectRatio: CardMetrics.aspectRatio,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
      ),
      itemBuilder: (context, index) => StaggeredAppear(
        index: index,
        child: DexCardTile(
          key: ValueKey(cards[index].animeId),
          card: cards[index],
          onTap: () => onCardTap(cards[index]),
        ),
      ),
    );
  }
}
