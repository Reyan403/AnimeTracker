import 'dart:math' as math;

import 'package:flutter/material.dart';

class Spark {
  const Spark({
    required this.angle,
    required this.reach,
    required this.size,
    required this.isGlow,
  });

  final double angle;
  final double reach;
  final double size;
  final bool isGlow;

  static List<Spark> generate(int count) {
    final random = math.Random(count * 31 + 7);

    return [
      for (var index = 0; index < count; index++)
        Spark(
          angle: random.nextDouble() * 2 * math.pi,
          reach: 0.35 + random.nextDouble() * 0.65,
          size: 3 + random.nextDouble() * 6,
          isGlow: index.isOdd,
        ),
    ];
  }
}

class BurstPainter extends CustomPainter {
  const BurstPainter({
    required this.progress,
    required this.center,
    required this.tone,
    required this.glow,
    required this.sparks,
    required this.hasFlash,
  });

  static const double flashSpan = 0.22;
  static const double flashPeak = 0.6;

  final double progress;
  final Alignment center;
  final Color tone;
  final Color glow;
  final List<Spark> sparks;
  final bool hasFlash;

  @override
  void paint(Canvas canvas, Size size) {
    final origin = center.alongSize(size);
    final eased = Curves.easeOutCubic.transform(progress);
    final fade = 1 - progress;
    final radius = size.shortestSide * (0.25 + 0.65 * eased);

    if (hasFlash && progress < flashSpan) {
      final strength = math.sin(progress / flashSpan * math.pi) * flashPeak;
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = glow.withValues(alpha: strength),
      );
    }

    canvas.drawCircle(
      origin,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            tone.withValues(alpha: 0.7 * fade),
            tone.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: origin, radius: radius)),
    );

    for (final spark in sparks) {
      final distance = radius * spark.reach * 1.3;
      final position =
          origin +
          Offset(math.cos(spark.angle), math.sin(spark.angle)) * distance;

      canvas.drawCircle(
        position,
        spark.size * fade,
        Paint()..color = (spark.isGlow ? glow : tone).withValues(alpha: fade),
      );
    }
  }

  @override
  bool shouldRepaint(BurstPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
