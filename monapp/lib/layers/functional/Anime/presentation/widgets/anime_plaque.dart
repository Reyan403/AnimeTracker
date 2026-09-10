import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';
import '../../../../technical/Theme/app_spacing.dart';
import 'plaque_dot_painter.dart';

class AnimePlaque extends StatelessWidget {
  const AnimePlaque({required this.title, super.key});

  final String title;

  static bool _isLetter(String character) =>
      character.toLowerCase() != character.toUpperCase();

  String get _initials => title
      .split('')
      .where(_isLetter)
      .take(2)
      .join()
      .toUpperCase();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.plaqueWidth,
      height: AppSpacing.plaqueHeight,
      child: CustomPaint(
        painter: const PlaqueDotPainter(),
        child: Container(
          color: AppColors.plaqueBackground.withValues(alpha: 0.35),
          alignment: const Alignment(0, 0.45),
          child: Text(
            _initials,
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: AppColors.plaqueInk,
            ),
          ),
        ),
      ),
    );
  }
}
