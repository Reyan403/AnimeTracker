import 'package:flutter/material.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.cardSurface,
    required this.posterFallback,
    required this.posterFallbackInk,
    required this.toWatch,
    required this.watching,
    required this.completed,
    required this.skeletonBase,
    required this.skeletonHighlight,
  });

  static const AppPalette light = AppPalette(
    cardSurface: Color(0xFFFFFFFF),
    posterFallback: Color(0xFFE3E1F7),
    posterFallbackInk: Color(0xFF4A4780),
    toWatch: Color(0xFF3F51B5),
    watching: Color(0xFF0B7A75),
    completed: Color(0xFF5A6B3A),
    skeletonBase: Color(0xFFE6E5EE),
    skeletonHighlight: Color(0xFFF6F5FB),
  );

  static const AppPalette dark = AppPalette(
    cardSurface: Color(0xFF1E1D2B),
    posterFallback: Color(0xFF2C2B45),
    posterFallbackInk: Color(0xFFB9B6F2),
    toWatch: Color(0xFF9FA8FF),
    watching: Color(0xFF5CD6CD),
    completed: Color(0xFFB7CC8A),
    skeletonBase: Color(0xFF2A2938),
    skeletonHighlight: Color(0xFF3A3950),
  );

  final Color cardSurface;
  final Color posterFallback;
  final Color posterFallbackInk;
  final Color toWatch;
  final Color watching;
  final Color completed;
  final Color skeletonBase;
  final Color skeletonHighlight;

  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>()!;

  @override
  AppPalette copyWith({
    Color? cardSurface,
    Color? posterFallback,
    Color? posterFallbackInk,
    Color? toWatch,
    Color? watching,
    Color? completed,
    Color? skeletonBase,
    Color? skeletonHighlight,
  }) =>
      AppPalette(
        cardSurface: cardSurface ?? this.cardSurface,
        posterFallback: posterFallback ?? this.posterFallback,
        posterFallbackInk: posterFallbackInk ?? this.posterFallbackInk,
        toWatch: toWatch ?? this.toWatch,
        watching: watching ?? this.watching,
        completed: completed ?? this.completed,
        skeletonBase: skeletonBase ?? this.skeletonBase,
        skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
      );

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }

    return AppPalette(
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      posterFallback: Color.lerp(posterFallback, other.posterFallback, t)!,
      posterFallbackInk:
          Color.lerp(posterFallbackInk, other.posterFallbackInk, t)!,
      toWatch: Color.lerp(toWatch, other.toWatch, t)!,
      watching: Color.lerp(watching, other.watching, t)!,
      completed: Color.lerp(completed, other.completed, t)!,
      skeletonBase: Color.lerp(skeletonBase, other.skeletonBase, t)!,
      skeletonHighlight:
          Color.lerp(skeletonHighlight, other.skeletonHighlight, t)!,
    );
  }
}
