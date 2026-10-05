import 'package:flutter/material.dart';

import '../cubit/dex_state.dart';
import '../detail/dex_card_dialog.dart';
import 'collection_controls.dart';
import 'dex_grid.dart';
import 'dex_no_results.dart';

class CollectionResults extends StatelessWidget {
  const CollectionResults({required this.state, super.key});

  final DexState state;

  @override
  Widget build(BuildContext context) {
    final visible = state.visibleCards;

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: CollectionControls(state: state, visibleCount: visible.length),
        ),
        if (visible.isEmpty)
          const SliverToBoxAdapter(child: DexNoResults())
        else
          DexGrid(
            cards: visible,
            onCardTap: (card) => DexCardDialog.show(context, card),
          ),
      ],
    );
  }
}
