import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static const String _serif = 'serif';

  static ThemeData get editorial {
    const scheme = ColorScheme.light(
      primary: AppColors.accent,
      onPrimary: AppColors.paper,
      surface: AppColors.paper,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.inkMuted,
      outline: AppColors.rule,
    );

    return ThemeData(
      colorScheme: scheme,
      fontFamily: _serif,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: _textTheme,
    );
  }

  static const TextTheme _textTheme = TextTheme(
    displaySmall: TextStyle(
      fontFamily: _serif,
      fontSize: 40,
      fontWeight: FontWeight.w700,
      height: 1.1,
      color: AppColors.ink,
    ),
    titleMedium: TextStyle(
      fontFamily: _serif,
      fontSize: 19,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    ),
    titleSmall: TextStyle(
      fontFamily: _serif,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
    ),
    bodyMedium: TextStyle(
      fontFamily: _serif,
      fontSize: 14,
      color: AppColors.inkMuted,
    ),
    bodySmall: TextStyle(
      fontFamily: _serif,
      fontSize: 13,
      color: AppColors.inkMuted,
    ),
    labelSmall: TextStyle(
      fontFamily: _serif,
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.6,
      color: AppColors.inkMuted,
    ),
  );
}
