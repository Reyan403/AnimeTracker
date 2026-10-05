import 'package:flutter/material.dart';

import '../app_spacing.dart';

class ResponsiveCardSliver extends StatelessWidget {
  const ResponsiveCardSliver({
    required this.itemCount,
    required this.itemBuilder,
    this.cardHeight = 200,
    super.key,
  });

  static const double gridThreshold = 760;
  static const double _maxCardWidth = 560;

  final int itemCount;
  final double cardHeight;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        if (constraints.crossAxisExtent < gridThreshold) {
          return SliverList.separated(
            itemCount: itemCount,
            itemBuilder: itemBuilder,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          );
        }

        return SliverGrid.builder(
          itemCount: itemCount,
          itemBuilder: itemBuilder,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: _maxCardWidth,
            mainAxisExtent: cardHeight,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
          ),
        );
      },
    );
  }
}
