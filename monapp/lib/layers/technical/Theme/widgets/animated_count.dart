import 'package:flutter/material.dart';

import '../app_motion.dart';

class AnimatedCount extends StatelessWidget {
  const AnimatedCount({
    required this.value,
    required this.builder,
    super.key,
  });

  final int value;
  final Widget Function(BuildContext context, int current) builder;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: value.toDouble()),
      duration: AppMotion.resolve(context, const Duration(milliseconds: 700)),
      curve: AppMotion.curve,
      builder: (context, current, _) => builder(context, current.round()),
    );
  }
}
