import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../card/card_metrics.dart';

class SealedPack extends StatefulWidget {
  const SealedPack({required this.isOpening, required this.onTap, super.key});

  static const double restingTilt = 0.03;
  static const double openingTilt = 0.1;

  final bool isOpening;
  final VoidCallback onTap;

  @override
  State<SealedPack> createState() => _SealedPackState();
}

class _SealedPackState extends State<SealedPack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (MediaQuery.disableAnimationsOf(context)) {
      _shake.stop();
    } else if (!_shake.isAnimating) {
      _shake.repeat();
    }
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final amplitude = widget.isOpening
        ? SealedPack.openingTilt
        : SealedPack.restingTilt;
    final frequency = widget.isOpening ? 4 : 1;

    return Semantics(
      button: true,
      label: l10n.dexPackTapHint,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.isOpening ? null : widget.onTap,
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _shake,
            child: const PackArtwork(),
            builder: (context, child) {
              final wave = math.sin(_shake.value * 2 * math.pi * frequency);

              return Transform.translate(
                offset: Offset(widget.isOpening ? wave * 5 : 0, 0),
                child: Transform.rotate(angle: wave * amplitude, child: child),
              );
            },
          ),
        ),
      ),
    );
  }
}

class PackArtwork extends StatelessWidget {
  const PackArtwork({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final foil = palette.starGlow.withValues(alpha: 0.85);

    return AspectRatio(
      aspectRatio: CardMetrics.aspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CardMetrics.radius),
          border: Border.all(color: palette.starGlow, width: 3),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [palette.candy, palette.rarityEpic, palette.sky],
          ),
          boxShadow: [
            BoxShadow(
              color: palette.rarityLegendary.withValues(alpha: 0.6),
              blurRadius: 28,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(color: foil),
              child: const SizedBox(
                height: AppSpacing.md,
                width: double.infinity,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, size: 72, color: palette.starGlow),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.dexPackLabel.toUpperCase(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: palette.starGlow,
                      shadows: [
                        Shadow(
                          color: palette.nebula,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(color: foil),
              child: const SizedBox(
                height: AppSpacing.md,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
