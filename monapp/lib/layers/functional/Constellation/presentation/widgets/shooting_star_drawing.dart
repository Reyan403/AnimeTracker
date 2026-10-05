import 'dart:math' as math;

import 'package:flutter/painting.dart';

import 'star_motion.dart';

abstract final class ShootingStarDrawing {
  static const double tailLength = 0.16;

  static void paint(
    Canvas canvas,
    Paint paint,
    Size size,
    double time,
    Color color,
  ) {
    final progress = StarMotion.shootingProgress(time);

    if (progress == null) {
      return;
    }

    final cycle = (time / StarMotion.shootingCycle).floor();
    final lane = 0.15 + 0.5 * ((math.sin(cycle * 12.9898) + 1) / 2);
    final start = Offset(size.width * 1.05, size.height * lane);
    final end = Offset(size.width * -0.05, size.height * (lane + 0.35));
    final head = Offset.lerp(start, end, progress)!;
    final tail = Offset.lerp(start, end, (progress - tailLength).clamp(0, 1))!;
    final fade = math.sin(progress * math.pi);

    paint
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0),
          color.withValues(alpha: fade),
        ],
      ).createShader(Rect.fromPoints(tail, head));
    canvas.drawLine(tail, head, paint);
    paint
      ..shader = null
      ..style = PaintingStyle.fill;
  }
}
