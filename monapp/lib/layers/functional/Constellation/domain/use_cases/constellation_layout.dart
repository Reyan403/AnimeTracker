import 'dart:math' as math;

import '../entities/constellation_link.dart';

class ConstellationPoint {
  const ConstellationPoint(this.x, this.y);

  final double x;
  final double y;
}

class ConstellationLayout {
  const ConstellationLayout._();

  static const double minBound = 0.06;
  static const double maxBound = 0.94;
  static const double _span = maxBound - minBound;
  static const double _goldenAngle = 2.399963229728653;
  static const double _centre = 0.5;

  static Map<int, ConstellationPoint> positions(
    Iterable<int> animeIds,
    Iterable<ConstellationLink> links,
  ) {
    final ids = animeIds.toSet().toList()..sort();
    final count = ids.length;

    if (count == 0) {
      return const {};
    }

    if (count == 1) {
      return {ids.first: const ConstellationPoint(_centre, _centre)};
    }

    final indexOf = {for (var i = 0; i < count; i++) ids[i]: i};
    final edges = _edgesOf(links, indexOf);
    final xs = List<double>.filled(count, 0);
    final ys = List<double>.filled(count, 0);

    _seed(ids, xs, ys);
    _relax(xs, ys, edges);
    _spread(xs);
    _spread(ys);

    return {
      for (var i = 0; i < count; i++) ids[i]: ConstellationPoint(xs[i], ys[i]),
    };
  }

  static List<_Edge> _edgesOf(
    Iterable<ConstellationLink> links,
    Map<int, int> indexOf,
  ) => [
    for (final link in links)
      if (indexOf.containsKey(link.fromId) &&
          indexOf.containsKey(link.toId) &&
          link.fromId != link.toId)
        _Edge(
          indexOf[link.fromId]!,
          indexOf[link.toId]!,
          1 + 0.25 * (link.sharedGenres - 1).clamp(0, 4),
        ),
  ];

  static void _seed(List<int> ids, List<double> xs, List<double> ys) {
    final count = ids.length;

    for (var i = 0; i < count; i++) {
      final random = math.Random(ids[i] * 7919 + 13);
      final radius = 0.36 * math.sqrt((i + 0.5) / count);
      final angle = i * _goldenAngle + random.nextDouble() * 0.6;
      final jitter = 0.02 * (random.nextDouble() - 0.5);

      xs[i] = _clamp(_centre + (radius + jitter) * math.cos(angle));
      ys[i] = _clamp(_centre + (radius + jitter) * math.sin(angle));
    }
  }

  static void _relax(List<double> xs, List<double> ys, List<_Edge> edges) {
    final count = xs.length;
    final iterations = count > 60 ? 80 : 140;
    final ideal = math.sqrt(_span * _span / count);
    final dx = List<double>.filled(count, 0);
    final dy = List<double>.filled(count, 0);
    var heat = 0.1;
    final cooling = heat / iterations;

    for (var step = 0; step < iterations; step++) {
      dx.fillRange(0, count, 0);
      dy.fillRange(0, count, 0);

      for (var i = 0; i < count; i++) {
        for (var j = i + 1; j < count; j++) {
          final vx = xs[i] - xs[j];
          final vy = ys[i] - ys[j];
          final distance = math.max(math.sqrt(vx * vx + vy * vy), 1e-4);
          final push = ideal * ideal / (distance * distance);

          dx[i] += vx * push;
          dy[i] += vy * push;
          dx[j] -= vx * push;
          dy[j] -= vy * push;
        }
      }

      for (final edge in edges) {
        final vx = xs[edge.from] - xs[edge.to];
        final vy = ys[edge.from] - ys[edge.to];
        final distance = math.max(math.sqrt(vx * vx + vy * vy), 1e-4);
        final pull = distance / ideal * edge.strength;

        dx[edge.from] -= vx * pull;
        dy[edge.from] -= vy * pull;
        dx[edge.to] += vx * pull;
        dy[edge.to] += vy * pull;
      }

      for (var i = 0; i < count; i++) {
        dx[i] += (_centre - xs[i]) * 0.3;
        dy[i] += (_centre - ys[i]) * 0.3;

        final length = math.max(math.sqrt(dx[i] * dx[i] + dy[i] * dy[i]), 1e-9);
        final move = math.min(length, heat);

        xs[i] = _clamp(xs[i] + dx[i] / length * move);
        ys[i] = _clamp(ys[i] + dy[i] / length * move);
      }

      heat -= cooling;
    }
  }

  static void _spread(List<double> values) {
    final low = values.reduce(math.min);
    final high = values.reduce(math.max);
    final range = high - low;

    for (var i = 0; i < values.length; i++) {
      values[i] = range < 1e-3
          ? _centre
          : _clamp(minBound + (values[i] - low) / range * _span);
    }
  }

  static double _clamp(double value) => value.clamp(minBound, maxBound);
}

class _Edge {
  const _Edge(this.from, this.to, this.strength);

  final int from;
  final int to;
  final double strength;
}
