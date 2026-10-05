import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_palette.dart';
import 'sky_clock_builder.dart';
import 'star_drawing.dart';
import 'star_motion.dart';
import 'star_palette.dart';

class MiniSky extends StatelessWidget {
  const MiniSky({this.scale = 1, this.pulseDepth = 0.25, super.key});

  final double scale;
  final double pulseDepth;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return SkyClockBuilder(
      builder: (context, clock, isAnimated) => RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,
          painter: MiniSkyPainter(
            palette: palette,
            clock: clock,
            isAnimated: isAnimated,
            scale: scale,
            pulseDepth: pulseDepth,
          ),
        ),
      ),
    );
  }
}

class MiniSkyPainter extends CustomPainter {
  MiniSkyPainter({
    required this.palette,
    required this.clock,
    required this.isAnimated,
    required this.scale,
    required this.pulseDepth,
  }) : super(repaint: clock);

  static const List<Offset> points = [
    Offset(0.12, 0.62),
    Offset(0.3, 0.3),
    Offset(0.5, 0.55),
    Offset(0.68, 0.22),
    Offset(0.86, 0.5),
    Offset(0.62, 0.82),
    Offset(0.34, 0.84),
  ];

  static const List<double> radii = [3.2, 4.4, 5.6, 3.6, 4.8, 3.2, 4];

  static const List<List<int>> links = [
    [0, 1],
    [1, 2],
    [2, 3],
    [3, 4],
    [2, 5],
    [5, 6],
  ];

  final AppPalette palette;
  final AnimationController clock;
  final bool isAnimated;
  final double scale;
  final double pulseDepth;

  @override
  void paint(Canvas canvas, Size size) {
    final time = isAnimated ? clock.value : StarMotion.restTime;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = palette.starGlow.withValues(alpha: 0.3);

    Offset at(int index) =>
        Offset(points[index].dx * size.width, points[index].dy * size.height);

    for (final link in links) {
      canvas.drawLine(at(link[0]), at(link[1]), paint);
    }

    paint.style = PaintingStyle.fill;

    for (var index = 0; index < points.length; index++) {
      StarDrawing.paint(
        canvas,
        paint,
        palette: palette,
        center: at(index),
        radius: radii[index] * scale,
        color: StarPalette.colorAt(palette, index),
        brightness: StarMotion.twinkle(time, index * 3, depth: pulseDepth),
        isSparkle: index.isOdd,
      );
    }
  }

  @override
  bool shouldRepaint(MiniSkyPainter old) =>
      old.palette != palette ||
      old.isAnimated != isAnimated ||
      old.scale != scale;
}
