import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_palette.dart';
import '../../../Anime/domain/entities/watch_status.dart';
import '../../domain/entities/constellation.dart';
import '../../domain/entities/constellation_star.dart';
import 'shooting_star_drawing.dart';
import 'star_drawing.dart';
import 'star_layout.dart';
import 'star_motion.dart';
import 'star_palette.dart';

class ConstellationPainter extends CustomPainter {
  ConstellationPainter({
    required this.constellation,
    required this.palette,
    required this.clock,
    required this.isAnimated,
    required this.inset,
    this.selectedId,
    this.genreSlug,
  }) : _colors = StarPalette.colorsOf(palette, constellation.genres),
       _indexes = {
         for (var i = 0; i < constellation.stars.length; i++)
           constellation.stars[i].animeId: i,
       },
       super(repaint: clock);

  static const double dimmedAlpha = 0.16;

  final Constellation constellation;
  final AppPalette palette;
  final AnimationController clock;
  final bool isAnimated;
  final EdgeInsets inset;
  final int? selectedId;
  final String? genreSlug;

  final Map<String, Color> _colors;
  final Map<int, int> _indexes;
  final Paint _paint = Paint();

  double get _time => isAnimated ? clock.value : StarMotion.restTime;

  bool _isLit(ConstellationStar star) =>
      genreSlug == null || star.genreSlug == genreSlug;

  double _appearOf(int animeId, double time) => StarMotion.appear(
    time,
    _indexes[animeId] ?? 0,
    constellation.stars.length,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final time = _time;
    final points = {
      for (final star in constellation.stars)
        star.animeId: StarLayout.positionOf(star, size, inset),
    };
    final stars = {for (final s in constellation.stars) s.animeId: s};

    _paintLinks(canvas, time, points, stars);

    for (final star in constellation.stars) {
      _paintStar(canvas, time, star, points[star.animeId]!);
    }

    final selected = stars[selectedId];

    if (selected != null) {
      _paintRing(canvas, time, selected, points[selected.animeId]!);
    }

    if (isAnimated) {
      ShootingStarDrawing.paint(canvas, _paint, size, time, palette.starGlow);
    }
  }

  void _paintLinks(
    Canvas canvas,
    double time,
    Map<int, Offset> points,
    Map<int, ConstellationStar> stars,
  ) {
    _paint
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final link in constellation.links) {
      final from = stars[link.fromId];
      final to = stars[link.toId];

      if (from == null || to == null) {
        continue;
      }

      final isStrong = link.sharedGenres >= 2;
      final lit = _isLit(from) && _isLit(to) ? 1.0 : dimmedAlpha;
      final appear = math
          .min(_appearOf(from.animeId, time), _appearOf(to.animeId, time))
          .clamp(0.0, 1.0);

      _paint
        ..strokeWidth = isStrong ? 1.6 : 0.8
        ..color = palette.starGlow.withValues(
          alpha: (isStrong ? 0.5 : 0.16) * lit * appear,
        );
      canvas.drawLine(points[link.fromId]!, points[link.toId]!, _paint);
    }

    _paint.style = PaintingStyle.fill;
  }

  void _paintStar(
    Canvas canvas,
    double time,
    ConstellationStar star,
    Offset center,
  ) {
    final appear = _appearOf(star.animeId, time);
    final color = _colors[star.genreSlug] ?? palette.starGlow;
    final twinkle = StarMotion.twinkle(time, star.animeId);

    StarDrawing.paint(
      canvas,
      _paint,
      palette: palette,
      center: center,
      radius: StarLayout.radiusOf(star) * appear,
      color: color,
      brightness: twinkle * (_isLit(star) ? 1 : dimmedAlpha),
      isSparkle: star.status == WatchStatus.completed,
    );
  }

  void _paintRing(
    Canvas canvas,
    double time,
    ConstellationStar star,
    Offset center,
  ) {
    final pulse = isAnimated ? StarMotion.pulse(time) : 0.0;
    final radius = StarLayout.radiusOf(star) * 2.6 + 3 * pulse;

    _paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..color = palette.starGlow.withValues(alpha: 0.85 - 0.25 * pulse);
    canvas
      ..drawCircle(center, radius, _paint)
      ..drawCircle(
        center,
        radius + 7,
        _paint..color = _paint.color.withValues(alpha: 0.25),
      );
    _paint.style = PaintingStyle.fill;
  }

  @override
  bool shouldRepaint(ConstellationPainter old) =>
      old.constellation != constellation ||
      old.selectedId != selectedId ||
      old.genreSlug != genreSlug ||
      old.palette != palette ||
      old.isAnimated != isAnimated ||
      old.inset != inset;
}
