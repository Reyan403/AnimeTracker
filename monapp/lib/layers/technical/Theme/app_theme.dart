import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import 'app_palette.dart';
import 'app_spacing.dart';

abstract final class AppTheme {
  static const String _display = 'Bangers';
  static const Color _inkOnBright = Color(0xFF1B1535);

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFFF3D81),
    onPrimary: _inkOnBright,
    primaryContainer: Color(0xFFFFE27A),
    onPrimaryContainer: _inkOnBright,
    secondary: Color(0xFFFFD23F),
    onSecondary: _inkOnBright,
    secondaryContainer: Color(0xFFC9F0FF),
    onSecondaryContainer: _inkOnBright,
    tertiary: Color(0xFF28C7F5),
    onTertiary: _inkOnBright,
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFFF6E5),
    onSurface: _inkOnBright,
    onSurfaceVariant: Color(0xFF4A426B),
    outline: _inkOnBright,
    outlineVariant: Color(0xFF8E86B0),
    surfaceContainer: Color(0xFFFFFFFF),
    surfaceContainerHighest: Color(0xFFFFE9B8),
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFF6FA5),
    onPrimary: _inkOnBright,
    primaryContainer: Color(0xFF4B3FA0),
    onPrimaryContainer: Color(0xFFFFE27A),
    secondary: Color(0xFFFFD23F),
    onSecondary: _inkOnBright,
    secondaryContainer: Color(0xFF2E3F8F),
    onSecondaryContainer: Color(0xFFC9F0FF),
    tertiary: Color(0xFF5CD6FF),
    onTertiary: _inkOnBright,
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    surface: Color(0xFF130F2B),
    onSurface: Color(0xFFF5EEFF),
    onSurfaceVariant: Color(0xFFC9BEF0),
    outline: Color(0xFFB9A8FF),
    outlineVariant: Color(0xFF6E62B8),
    surfaceContainer: Color(0xFF1B1640),
    surfaceContainerHighest: Color(0xFF2E2762),
  );

  static ThemeData get light => _build(_lightScheme, AppPalette.light);

  static ThemeData get dark => _build(_darkScheme, AppPalette.dark);

  static ThemeData _build(ColorScheme scheme, AppPalette palette) {
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    final outline = BorderSide(color: palette.ink, width: 2.5);
    const stadium = StadiumBorder();

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      extensions: [palette],
      textTheme: _textTheme(base.textTheme),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: _display,
          fontSize: 28,
          letterSpacing: 1,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: palette.cardSurface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: outline,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: scheme.surfaceContainer,
        elevation: 0,
        indicatorColor: palette.sun,
        indicatorShape: StadiumBorder(side: outline),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
            color: scheme.onSurface,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 26,
            color: states.contains(WidgetState.selected)
                ? _inkOnBright
                : scheme.onSurface,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: palette.sun,
        indicatorShape: StadiumBorder(side: outline),
        selectedIconTheme: const IconThemeData(color: _inkOnBright),
        unselectedIconTheme: IconThemeData(color: scheme.onSurface),
        selectedLabelTextStyle: TextStyle(
          fontWeight: FontWeight.w800,
          color: scheme.onSurface,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        labelType: NavigationRailLabelType.all,
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(palette.cardSurface),
        side: WidgetStatePropertyAll(outline),
        shape: const WidgetStatePropertyAll(stadium),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(AppSpacing.minTouchTarget, 48),
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          side: outline,
          shape: stadium,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(AppSpacing.minTouchTarget, 48),
          foregroundColor: scheme.onSurface,
          backgroundColor: palette.cardSurface,
          side: outline,
          shape: stadium,
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.accentText,
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          side: BorderSide(color: palette.ink, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.cardSurface,
        selectedColor: palette.sun,
        checkmarkColor: _inkOnBright,
        side: BorderSide(color: palette.ink, width: 2),
        shape: stadium,
        labelStyle: WidgetStateTextStyle.resolveWith(
          (states) => TextStyle(
            fontWeight: FontWeight.w700,
            color: states.contains(WidgetState.selected)
                ? _inkOnBright
                : scheme.onSurface,
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: palette.cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          side: outline,
        ),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStatePropertyAll(palette.ink),
        thumbColor: WidgetStatePropertyAll(palette.ink),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? palette.candy
              : palette.cardSurface,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.candy,
        linearTrackColor: palette.skeletonBase,
      ),
      dividerTheme: DividerThemeData(color: palette.ink, thickness: 2),
    );
  }

  static TextTheme _textTheme(TextTheme base) => base.copyWith(
    displaySmall: base.displaySmall?.copyWith(
      fontFamily: _display,
      fontSize: 50,
      height: 1,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontFamily: _display,
      fontSize: 42,
      letterSpacing: 1,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontFamily: _display,
      fontSize: 32,
      letterSpacing: 1,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: base.titleLarge?.copyWith(
      fontFamily: _display,
      fontSize: 26,
      letterSpacing: 1,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w800),
    titleSmall: base.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    labelMedium: base.labelMedium?.copyWith(fontWeight: FontWeight.w800),
  );
}
