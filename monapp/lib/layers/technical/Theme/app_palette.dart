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
    required this.ink,
    required this.hardShadow,
    required this.sun,
    required this.candy,
    required this.sky,
    required this.accentText,
    required this.halftone,
    required this.rarityCommon,
    required this.rarityRare,
    required this.rarityEpic,
    required this.rarityLegendary,
    required this.nebula,
    required this.starGlow,
  });

  static const AppPalette light = AppPalette(
    cardSurface: Color(0xFFFFFFFF),
    posterFallback: Color(0xFFFFD23F),
    posterFallbackInk: Color(0xFF1B1535),
    toWatch: Color(0xFF0A6FA0),
    watching: Color(0xFFC2185B),
    completed: Color(0xFF1E7F4F),
    skeletonBase: Color(0xFFFFE8B0),
    skeletonHighlight: Color(0xFFFFF6DD),
    ink: Color(0xFF1B1535),
    hardShadow: Color(0xFF1B1535),
    sun: Color(0xFFFFD23F),
    candy: Color(0xFFFF3D81),
    sky: Color(0xFF28C7F5),
    accentText: Color(0xFFC2185B),
    halftone: Color(0xFFFFC7DD),
    rarityCommon: Color(0xFF6B6F85),
    rarityRare: Color(0xFF0A8FD0),
    rarityEpic: Color(0xFF8E3DFF),
    rarityLegendary: Color(0xFFFFB400),
    nebula: Color(0xFF14103A),
    starGlow: Color(0xFFFFF3B0),
  );

  static const AppPalette dark = AppPalette(
    cardSurface: Color(0xFF211B4A),
    posterFallback: Color(0xFF3A2F7A),
    posterFallbackInk: Color(0xFFFFD23F),
    toWatch: Color(0xFF7FDBFF),
    watching: Color(0xFFFF8FB8),
    completed: Color(0xFF8BF0B0),
    skeletonBase: Color(0xFF2E2762),
    skeletonHighlight: Color(0xFF453B8C),
    ink: Color(0xFFB9A8FF),
    hardShadow: Color(0xFFFF3D81),
    sun: Color(0xFFFFD23F),
    candy: Color(0xFFFF6FA5),
    sky: Color(0xFF5CD6FF),
    accentText: Color(0xFFFF8FB8),
    halftone: Color(0xFF2A2358),
    rarityCommon: Color(0xFFB7BCD6),
    rarityRare: Color(0xFF5CD6FF),
    rarityEpic: Color(0xFFC08BFF),
    rarityLegendary: Color(0xFFFFD23F),
    nebula: Color(0xFF0D0A2B),
    starGlow: Color(0xFFFFF3B0),
  );

  final Color cardSurface;
  final Color posterFallback;
  final Color posterFallbackInk;
  final Color toWatch;
  final Color watching;
  final Color completed;
  final Color skeletonBase;
  final Color skeletonHighlight;
  final Color ink;
  final Color hardShadow;
  final Color sun;
  final Color candy;
  final Color sky;
  final Color accentText;
  final Color halftone;
  final Color rarityCommon;
  final Color rarityRare;
  final Color rarityEpic;
  final Color rarityLegendary;
  final Color nebula;
  final Color starGlow;

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
    Color? ink,
    Color? hardShadow,
    Color? sun,
    Color? candy,
    Color? sky,
    Color? accentText,
    Color? halftone,
    Color? rarityCommon,
    Color? rarityRare,
    Color? rarityEpic,
    Color? rarityLegendary,
    Color? nebula,
    Color? starGlow,
  }) => AppPalette(
    cardSurface: cardSurface ?? this.cardSurface,
    posterFallback: posterFallback ?? this.posterFallback,
    posterFallbackInk: posterFallbackInk ?? this.posterFallbackInk,
    toWatch: toWatch ?? this.toWatch,
    watching: watching ?? this.watching,
    completed: completed ?? this.completed,
    skeletonBase: skeletonBase ?? this.skeletonBase,
    skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
    ink: ink ?? this.ink,
    hardShadow: hardShadow ?? this.hardShadow,
    sun: sun ?? this.sun,
    candy: candy ?? this.candy,
    sky: sky ?? this.sky,
    accentText: accentText ?? this.accentText,
    halftone: halftone ?? this.halftone,
    rarityCommon: rarityCommon ?? this.rarityCommon,
    rarityRare: rarityRare ?? this.rarityRare,
    rarityEpic: rarityEpic ?? this.rarityEpic,
    rarityLegendary: rarityLegendary ?? this.rarityLegendary,
    nebula: nebula ?? this.nebula,
    starGlow: starGlow ?? this.starGlow,
  );

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }

    Color mix(Color from, Color to) => Color.lerp(from, to, t)!;

    return AppPalette(
      cardSurface: mix(cardSurface, other.cardSurface),
      posterFallback: mix(posterFallback, other.posterFallback),
      posterFallbackInk: mix(posterFallbackInk, other.posterFallbackInk),
      toWatch: mix(toWatch, other.toWatch),
      watching: mix(watching, other.watching),
      completed: mix(completed, other.completed),
      skeletonBase: mix(skeletonBase, other.skeletonBase),
      skeletonHighlight: mix(skeletonHighlight, other.skeletonHighlight),
      ink: mix(ink, other.ink),
      hardShadow: mix(hardShadow, other.hardShadow),
      sun: mix(sun, other.sun),
      candy: mix(candy, other.candy),
      sky: mix(sky, other.sky),
      accentText: mix(accentText, other.accentText),
      halftone: mix(halftone, other.halftone),
      rarityCommon: mix(rarityCommon, other.rarityCommon),
      rarityRare: mix(rarityRare, other.rarityRare),
      rarityEpic: mix(rarityEpic, other.rarityEpic),
      rarityLegendary: mix(rarityLegendary, other.rarityLegendary),
      nebula: mix(nebula, other.nebula),
      starGlow: mix(starGlow, other.starGlow),
    );
  }
}
