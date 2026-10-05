import 'package:flutter/material.dart';

import '../app_motion.dart';

class StaggeredAppear extends StatelessWidget {
  const StaggeredAppear({required this.index, required this.child, super.key});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final rank = index.clamp(0, AppMotion.maxStaggered);
    final duration = AppMotion.resolve(
      context,
      AppMotion.standard + AppMotion.stagger * rank,
    );

    if (duration == Duration.zero) {
      return child;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: AppMotion.curve,
      child: child,
      builder: (context, progress, child) => Opacity(
        opacity: progress,
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - progress)),
          child: child,
        ),
      ),
    );
  }
}
