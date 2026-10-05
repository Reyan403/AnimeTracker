import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_palette.dart';

class AppBackdrop extends StatefulWidget {
  const AppBackdrop({required this.child, super.key});

  final Widget child;

  @override
  State<AppBackdrop> createState() => _AppBackdropState();
}

class _AppBackdropState extends State<AppBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 9),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(
            child: CustomPaint(painter: _HalftonePainter(palette.halftone)),
          ),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                painter: _SparklePainter(
                  progress: _controller.value,
                  colors: [palette.sun, palette.sky, palette.candy],
                ),
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _HalftonePainter extends CustomPainter {
  const _HalftonePainter(this.color);

  static const double _spacing = 16;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final reach = size.width * 0.95;

    for (var y = 0.0; y < size.height; y += _spacing) {
      for (var x = size.width; x > 0; x -= _spacing) {
        final distance = math.sqrt(math.pow(size.width - x, 2) + y * y);

        if (distance >= reach) {
          continue;
        }

        canvas.drawCircle(Offset(x, y), 5.5 * (1 - distance / reach), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_HalftonePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _SparklePainter extends CustomPainter {
  const _SparklePainter({required this.progress, required this.colors});

  static const List<Offset> _anchors = [
    Offset(0.1, 0.16),
    Offset(0.88, 0.1),
    Offset(0.93, 0.5),
    Offset(0.06, 0.62),
    Offset(0.62, 0.9),
  ];

  final double progress;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    for (var index = 0; index < _anchors.length; index++) {
      final phase = progress * 2 * math.pi + index * 1.3;
      final pulse = 0.65 + 0.35 * math.sin(phase);
      final anchor = _anchors[index];

      canvas
        ..save()
        ..translate(
          size.width * anchor.dx,
          size.height * anchor.dy + 6 * math.sin(phase * 0.5),
        )
        ..rotate(0.4 * math.sin(phase * 0.7))
        ..drawPath(
          _star(16 * pulse),
          Paint()
            ..color = colors[index % colors.length].withValues(alpha: 0.85),
        )
        ..restore();
    }
  }

  static Path _star(double radius) {
    final inner = radius * 0.28;

    return Path()
      ..moveTo(0, -radius)
      ..lineTo(inner, -inner)
      ..lineTo(radius, 0)
      ..lineTo(inner, inner)
      ..lineTo(0, radius)
      ..lineTo(-inner, inner)
      ..lineTo(-radius, 0)
      ..lineTo(-inner, -inner)
      ..close();
  }

  @override
  bool shouldRepaint(_SparklePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
