import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_spacing.dart';

class SliverContentPadding extends StatelessWidget {
  const SliverContentPadding({
    required this.sliver,
    this.top = 0,
    this.bottom = 0,
    super.key,
  });

  final Widget sliver;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final side = math.max(
          AppSpacing.lg,
          (constraints.crossAxisExtent - AppSpacing.listMaxWidth) / 2,
        );

        return SliverPadding(
          padding: EdgeInsets.fromLTRB(side, top, side, bottom),
          sliver: sliver,
        );
      },
    );
  }
}
