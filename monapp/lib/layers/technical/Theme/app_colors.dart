import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF7C4DFF);
  static const Color surfaceLight = Color(0xFFF7F5FC);
  static const Color surfaceDark = Color(0xFF12101A);

  static const List<List<Color>> posterGradients = [
    [Color(0xFF7C4DFF), Color(0xFF2B1B6B)],
    [Color(0xFFFF4D8D), Color(0xFF6B1B3F)],
    [Color(0xFF00B8D4), Color(0xFF0B3D52)],
    [Color(0xFFFFA726), Color(0xFF6B3B0B)],
    [Color(0xFF26C281), Color(0xFF0B4A33)],
    [Color(0xFFEF5350), Color(0xFF5C1A18)],
  ];
}
