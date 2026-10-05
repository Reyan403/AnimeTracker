import 'package:flutter/material.dart';

import 'skeleton_box.dart';

class SkeletonBar extends StatelessWidget {
  const SkeletonBar({
    required this.widthFactor,
    required this.height,
    super.key,
  });

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: SkeletonBox(height: height, radius: height / 2),
    );
  }
}
