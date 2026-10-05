import 'package:flutter/painting.dart';

import '../../domain/entities/constellation_star.dart';

abstract final class StarLayout {
  static const double minRadius = 3;
  static const double radiusRange = 6;
  static const double hitRadius = 26;
  static const double padding = 28;

  static Rect areaOf(Size size, EdgeInsets inset) => Rect.fromLTRB(
    inset.left + padding,
    inset.top + padding,
    size.width - inset.right - padding,
    size.height - inset.bottom - padding,
  );

  static Offset positionOf(
    ConstellationStar star,
    Size size,
    EdgeInsets inset,
  ) {
    final area = areaOf(size, inset);

    return Offset(
      area.left + star.x * area.width,
      area.top + star.y * area.height,
    );
  }

  static double radiusOf(ConstellationStar star) =>
      minRadius + radiusRange * star.weight;

  static int? hitTest(
    Iterable<ConstellationStar> stars,
    Offset point,
    Size size,
    EdgeInsets inset, {
    double tolerance = hitRadius,
  }) {
    int? nearest;
    var best = double.infinity;

    for (final star in stars) {
      final distance = (positionOf(star, size, inset) - point).distance;
      final reach = tolerance + radiusOf(star);

      if (distance <= reach && distance < best) {
        best = distance;
        nearest = star.animeId;
      }
    }

    return nearest;
  }
}
