import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/skeleton_box.dart';
import '../card/card_metrics.dart';
import 'dex_grid.dart';

class DexSkeletonGrid extends StatelessWidget {
  const DexSkeletonGrid({super.key});

  static const int placeholderCount = 6;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: placeholderCount,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: DexGrid.maxTileWidth,
        childAspectRatio: CardMetrics.aspectRatio,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
      ),
      itemBuilder: (context, index) => const SkeletonBox(
        height: double.infinity,
        radius: CardMetrics.radius,
      ),
    );
  }
}
