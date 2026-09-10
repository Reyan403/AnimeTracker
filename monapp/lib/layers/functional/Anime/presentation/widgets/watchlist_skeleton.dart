import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';
import '../../../../technical/Theme/app_spacing.dart';
import 'skeleton_bar.dart';

class WatchlistSkeleton extends StatelessWidget {
  const WatchlistSkeleton({this.rowCount = 3, super.key});

  final int rowCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < rowCount; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSpacing.plaqueWidth,
                  height: AppSpacing.plaqueHeight,
                  color: AppColors.plaqueBackground,
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
      ],
    );
  }
}
