import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';
import '../../../../technical/Theme/app_spacing.dart';

class PlaqueDotPainter extends CustomPainter {
  const PlaqueDotPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.plaqueDot;

    for (var y = AppSpacing.plaqueDotSpacing / 2;
        y < size.height;
        y += AppSpacing.plaqueDotSpacing) {
      for (var x = AppSpacing.plaqueDotSpacing / 2;
          x < size.width;
          x += AppSpacing.plaqueDotSpacing) {
        canvas.drawCircle(Offset(x, y), AppSpacing.plaqueDotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(PlaqueDotPainter oldDelegate) => false;
}
