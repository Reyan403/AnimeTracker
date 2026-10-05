import 'dart:math' as math;

import 'package:flutter/animation.dart';

abstract final class StarMotion {
  static const double restTime = 100;
  static const double revealSeconds = 0.4;
  static const double revealSpread = 0.4;
  static const double shootingCycle = 11;
  static const double shootingStart = 8;
  static const double shootingLength = 0.9;

  static double appear(double time, int index, int count) {
    final start = count <= 1 ? 0.0 : revealSpread * index / count;
    final progress = ((time - start) / revealSeconds).clamp(0.0, 1.0);

    return Curves.easeOutBack.transform(progress).clamp(0.0, 1.2);
  }

  static double twinkle(double time, int seed, {double depth = 0.25}) =>
      1 - depth + depth * math.sin(time * 2.2 + seed * 1.7);

  static double pulse(double time) => math.sin(time * 5);

  static double? shootingProgress(double time) {
    final phase = (time % shootingCycle) - shootingStart;

    return phase < 0 || phase > shootingLength ? null : phase / shootingLength;
  }
}
