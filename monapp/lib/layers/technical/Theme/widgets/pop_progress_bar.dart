import 'package:flutter/material.dart';

import '../app_motion.dart';
import '../app_palette.dart';

class PopProgressBar extends StatelessWidget {
  const PopProgressBar({required this.value, this.height = 12, super.key});

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final radius = BorderRadius.circular(height);

    return TweenAnimationBuilder<double>(
      tween: Tween(end: value.clamp(0, 1)),
      duration: AppMotion.resolve(context, AppMotion.standard),
      curve: Curves.easeOutBack,
      builder: (context, progress, _) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: palette.ink, width: 2),
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Stack(
            children: [
              LinearProgressIndicator(
                value: progress.clamp(0, 1),
                minHeight: height,
                color: palette.candy,
                backgroundColor: palette.skeletonBase,
                borderRadius: BorderRadius.zero,
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _StripePainter(
                      fraction: progress.clamp(0, 1),
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StripePainter extends CustomPainter {
  const _StripePainter({required this.fraction, required this.color});

  static const double _gap = 14;
  static const double _width = 6;

  final double fraction;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final filled = size.width * fraction;
    final paint = Paint()..color = color;

    canvas.clipRect(Rect.fromLTWH(0, 0, filled, size.height));

    for (var x = -size.height; x < filled; x += _gap) {
      canvas.drawPath(
        Path()
          ..moveTo(x, size.height)
          ..lineTo(x + _width, size.height)
          ..lineTo(x + _width + size.height, 0)
          ..lineTo(x + size.height, 0)
          ..close(),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StripePainter oldDelegate) =>
      oldDelegate.fraction != fraction || oldDelegate.color != color;
}
