import 'dart:math' as math;

import 'package:flutter/painting.dart';

import '../../../../technical/Theme/app_palette.dart';

abstract final class StarDrawing {
  static final Path _sparkle = _sparklePath();

  static Path _sparklePath() {
    const pinch = 0.28;
    final path = Path();

    for (var corner = 0; corner < 8; corner++) {
      final angle = corner * math.pi / 4 - math.pi / 2;
      final radius = corner.isEven ? 1.0 : pinch;
      final point = Offset(math.cos(angle) * radius, math.sin(angle) * radius);

      corner == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }

    return path..close();
  }

  static void paint(
    Canvas canvas,
    Paint paint, {
    required AppPalette palette,
    required Offset center,
    required double radius,
    required Color color,
    required double brightness,
    required bool isSparkle,
  }) {
    if (radius <= 0 || brightness <= 0) {
      return;
    }

    for (var layer = 0; layer < 3; layer++) {
      paint.color = color.withValues(
        alpha: (brightness * (0.07 + 0.06 * (2 - layer))).clamp(0.0, 1.0),
      );
      canvas.drawCircle(center, radius * (3.4 - layer * 0.9), paint);
    }

    paint.color = Color.lerp(
      color,
      palette.starGlow,
      0.6,
    )!.withValues(alpha: brightness.clamp(0.0, 1.0));

    if (isSparkle) {
      canvas
        ..save()
        ..translate(center.dx, center.dy)
        ..scale(radius * 2.1)
        ..drawPath(_sparkle, paint)
        ..restore();
    } else {
      canvas.drawCircle(center, radius, paint);
    }
  }
}
