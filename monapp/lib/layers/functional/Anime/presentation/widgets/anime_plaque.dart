import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';
import '../../../../technical/Theme/app_spacing.dart';

class AnimePlaque extends StatelessWidget {
  const AnimePlaque({required this.title, super.key});

  final String title;

  static bool _isLetter(String character) =>
      character.toLowerCase() != character.toUpperCase();

  String get _initials =>
      title.split('').where(_isLetter).take(2).join().toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.plaqueWidth,
      height: AppSpacing.plaqueHeight,
      color: AppColors.plaqueBackground,
      alignment: const Alignment(0, 0.45),
      child: Text(
        _initials,
        style: const TextStyle(
          fontSize: 28,
          color: AppColors.plaqueInk,
        ),
      ),
    );
  }
}
