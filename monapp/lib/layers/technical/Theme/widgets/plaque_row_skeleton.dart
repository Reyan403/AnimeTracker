import 'package:flutter/material.dart';

import '../app_spacing.dart';
import 'pop_card.dart';
import 'skeleton_bar.dart';
import 'skeleton_box.dart';

class PlaqueRowSkeleton extends StatelessWidget {
  const PlaqueRowSkeleton({this.rowCount = 3, super.key});

  final int rowCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < rowCount; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: PopCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonBox(
                      width: AppSpacing.plaqueWidth,
                      height: AppSpacing.plaqueHeight,
                      radius: AppSpacing.radiusMd,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonBar(widthFactor: 0.8, height: 18),
                          SizedBox(height: AppSpacing.sm),
                          SkeletonBar(widthFactor: 0.5, height: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
