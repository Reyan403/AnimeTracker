import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import 'mini_sky.dart';

class ConstellationLoading extends StatelessWidget {
  const ConstellationLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        const MiniSky(scale: 1.8, pulseDepth: 0.5),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(
                AppLocalizations.of(context).constellationLoading,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(color: palette.starGlow),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
