import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_motion.dart';
import '../card/card_metrics.dart';

class FlipReveal extends StatefulWidget {
  const FlipReveal({required this.front, required this.back, super.key});

  static const Duration duration = Duration(milliseconds: 700);

  final Widget front;
  final Widget back;

  @override
  State<FlipReveal> createState() => _FlipRevealState();
}

class _FlipRevealState extends State<FlipReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flip = AnimationController(vsync: this);
  bool _hasStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasStarted) {
      _hasStarted = true;
      _flip.duration = AppMotion.resolve(context, FlipReveal.duration);
      _flip.forward();
    }
  }

  @override
  void dispose() {
    _flip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flip,
      builder: (context, _) {
        final angle = Curves.easeInOut.transform(_flip.value) * math.pi;
        final showsFront = angle > math.pi / 2;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, CardMetrics.tiltDepth)
            ..rotateY(angle),
          child: showsFront
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: widget.front,
                )
              : widget.back,
        );
      },
    );
  }
}
