import 'package:flutter/material.dart';

import '../app_motion.dart';
import '../app_palette.dart';

class PopTitle extends StatelessWidget {
  const PopTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final highlight = isDark
        ? palette.candy.withValues(alpha: 0.55)
        : palette.sun;

    return Align(
      alignment: Alignment.centerLeft,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: AppMotion.resolve(context, const Duration(milliseconds: 700)),
        curve: Curves.elasticOut,
        builder: (context, progress, child) => Transform.rotate(
          angle: -0.06 * (1 - progress),
          alignment: Alignment.centerLeft,
          child: Transform.scale(
            scale: 0.6 + 0.4 * progress,
            alignment: Alignment.centerLeft,
            child: child,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -8,
              right: -8,
              bottom: 6,
              height: 16,
              child: Transform(
                transform: Matrix4.skewX(-0.25),
                alignment: Alignment.center,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: highlight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Text(
              text,
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.onSurface,
                shadows: [
                  Shadow(color: palette.candy, offset: const Offset(3, 3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
