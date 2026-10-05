import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/constellation.dart';
import 'constellation_painter.dart';
import 'sky_clock_builder.dart';
import 'star_layout.dart';

class ConstellationSky extends StatelessWidget {
  const ConstellationSky({
    required this.constellation,
    required this.inset,
    required this.onStarTapped,
    this.selectedId,
    this.genreSlug,
    super.key,
  });

  static const double minScale = 1;
  static const double maxScale = 5;

  final Constellation constellation;
  final EdgeInsets inset;
  final ValueChanged<int?> onStarTapped;
  final int? selectedId;
  final String? genreSlug;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final label = AppLocalizations.of(context)
        .constellationSkyLabel(constellation.stars.length);

    return Semantics(
      label: label,
      child: SkyClockBuilder(
        builder: (context, clock, isAnimated) => LayoutBuilder(
          builder: (context, box) {
            final size = box.biggest;

            return InteractiveViewer(
              minScale: minScale,
              maxScale: maxScale,
              boundaryMargin: const EdgeInsets.all(AppSpacing.xl * 2),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (details) => onStarTapped(
                  StarLayout.hitTest(
                    constellation.stars.where(
                      (star) =>
                          genreSlug == null || star.genreSlug == genreSlug,
                    ),
                    details.localPosition,
                    size,
                    inset,
                  ),
                ),
                child: RepaintBoundary(
                  child: CustomPaint(
                    size: size,
                    painter: ConstellationPainter(
                      constellation: constellation,
                      palette: palette,
                      clock: clock,
                      isAnimated: isAnimated,
                      inset: inset,
                      selectedId: selectedId,
                      genreSlug: genreSlug,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
