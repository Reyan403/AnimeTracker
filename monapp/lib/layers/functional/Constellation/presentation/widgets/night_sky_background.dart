import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_palette.dart';

class NightSkyBackground extends StatelessWidget {
  const NightSkyBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return RepaintBoundary(
      child: CustomPaint(
        painter: _NightSkyPainter(palette),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _NightSkyPainter extends CustomPainter {
  _NightSkyPainter(this.palette) : _dust = _dustOf(240);

  static const int dustCount = 90;

  final AppPalette palette;
  final List<Offset> _dust;

  static List<Offset> _dustOf(int seed) {
    final random = math.Random(seed);

    return [
      for (var i = 0; i < dustCount; i++)
        Offset(random.nextDouble(), random.nextDouble()),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            palette.nebula,
            Color.lerp(palette.nebula, palette.rarityEpic, 0.28)!,
          ],
        ).createShader(rect),
    );

    _halo(canvas, size, const Alignment(-0.7, -0.5), palette.candy, 0.22);
    _halo(canvas, size, const Alignment(0.8, 0.35), palette.sky, 0.18);
    _halo(canvas, size, const Alignment(-0.2, 0.9), palette.rarityEpic, 0.25);

    final paint = Paint();

    for (var i = 0; i < _dust.length; i++) {
      paint.color = palette.starGlow.withValues(alpha: 0.15 + 0.05 * (i % 9));
      canvas.drawCircle(
        Offset(_dust[i].dx * size.width, _dust[i].dy * size.height),
        i % 7 == 0 ? 1.4 : 0.8,
        paint,
      );
    }
  }

  void _halo(
    Canvas canvas,
    Size size,
    Alignment alignment,
    Color color,
    double alpha,
  ) {
    final center = alignment.alongSize(size);
    final radius = size.shortestSide * 0.7;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: alpha),
            color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  @override
  bool shouldRepaint(_NightSkyPainter old) => old.palette != palette;
}
