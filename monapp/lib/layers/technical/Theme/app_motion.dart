import 'package:flutter/widgets.dart';

abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration standard = Duration(milliseconds: 300);
  static const Duration stagger = Duration(milliseconds: 40);
  static const int maxStaggered = 8;
  static const Curve curve = Curves.easeOutCubic;

  static Duration resolve(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}
