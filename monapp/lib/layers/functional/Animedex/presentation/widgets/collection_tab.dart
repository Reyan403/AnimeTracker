import 'package:flutter/material.dart';

import '../cubit/dex_state.dart';
import 'collection_results.dart';
import 'dex_empty_collection.dart';
import 'dex_failure_message.dart';
import 'dex_skeleton_grid.dart';

class CollectionTab extends StatelessWidget {
  const CollectionTab({required this.state, super.key});

  final DexState state;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: switch (state.status) {
        DexStatus.loading => const [DexSkeletonGrid()],
        DexStatus.failure => const [
          SliverToBoxAdapter(child: DexFailureMessage()),
        ],
        DexStatus.empty => [
          SliverToBoxAdapter(child: DexEmptyCollection(state: state)),
        ],
        DexStatus.success => [CollectionResults(state: state)],
      },
    );
  }
}
