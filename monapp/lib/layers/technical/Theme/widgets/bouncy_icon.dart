import 'package:flutter/material.dart';

import '../app_motion.dart';

class BouncyIcon extends StatelessWidget {
  const BouncyIcon({required this.icon, required this.isSelected, super.key});

  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(isSelected),
      tween: Tween(begin: isSelected ? 0.4 : 1, end: 1),
      duration: AppMotion.resolve(context, const Duration(milliseconds: 650)),
      curve: Curves.elasticOut,
      builder: (context, scale, child) => Transform.scale(
        scale: scale,
        child: Transform.rotate(angle: (1 - scale) * -0.5, child: child),
      ),
      child: Icon(icon),
    );
  }
}
