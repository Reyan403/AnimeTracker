import 'package:flutter/material.dart';

import '../app_palette.dart';

class AnimePlaque extends StatelessWidget {
  const AnimePlaque({required this.title, super.key});

  final String title;

  static bool _isLetter(String character) =>
      character.toLowerCase() != character.toUpperCase();

  String get _initials =>
      title.split('').where(_isLetter).take(2).join().toUpperCase();

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return ColoredBox(
      color: palette.posterFallback,
      child: Center(
        child: Text(
          _initials,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: palette.posterFallbackInk,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
