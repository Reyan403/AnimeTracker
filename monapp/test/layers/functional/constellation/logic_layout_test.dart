import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Constellation/domain/entities/constellation_link.dart';
import 'package:monapp/layers/functional/Constellation/domain/use_cases/constellation_layout.dart';

List<int> idsOf(int count) => [for (var i = 1; i <= count; i++) i * 3];

List<ConstellationLink> ringOf(List<int> ids) => [
  for (var i = 0; i < ids.length - 1; i++)
    ConstellationLink(fromId: ids[i], toId: ids[i + 1], sharedGenres: 1),
];

double distance(ConstellationPoint a, ConstellationPoint b) =>
    math.sqrt(math.pow(a.x - b.x, 2) + math.pow(a.y - b.y, 2));

void main() {
  group('ConstellationLayout', () {
    test('une liste vide ne donne aucune position', () {
      expect(ConstellationLayout.positions(const [], const []), isEmpty);
    });

    test('un seul anime est au centre', () {
      final points = ConstellationLayout.positions(const [7], const []);

      expect(points[7]!.x, 0.5);
      expect(points[7]!.y, 0.5);
    });

    test('même entrée, mêmes positions', () {
      final ids = idsOf(40);
      final links = ringOf(ids);
      final first = ConstellationLayout.positions(ids, links);
      final second = ConstellationLayout.positions(ids, links);

      for (final id in ids) {
        expect(second[id]!.x, first[id]!.x);
        expect(second[id]!.y, first[id]!.y);
      }
    });

    test("l'ordre des ids n'influence pas le résultat", () {
      final ids = idsOf(25);
      final links = ringOf(ids);
      final straight = ConstellationLayout.positions(ids, links);
      final reversed = ConstellationLayout.positions(ids.reversed, links);

      for (final id in ids) {
        expect(reversed[id]!.x, straight[id]!.x);
        expect(reversed[id]!.y, straight[id]!.y);
      }
    });

    test('des ids différents donnent un ciel différent', () {
      final ids = idsOf(10);
      final shifted = [for (final id in ids) id + 1];
      final one = ConstellationLayout.positions(ids, const []);
      final other = ConstellationLayout.positions(shifted, const []);
      final identical = [
        for (var i = 0; i < ids.length; i++)
          one[ids[i]]!.x == other[shifted[i]]!.x &&
              one[ids[i]]!.y == other[shifted[i]]!.y,
      ];

      expect(identical.every((same) => same), isFalse);
    });

    test('toutes les positions restent dans les marges', () {
      for (final count in [2, 3, 10, 60, 100]) {
        final ids = idsOf(count);
        final points = ConstellationLayout.positions(ids, ringOf(ids));

        expect(points, hasLength(count));
        for (final point in points.values) {
          expect(point.x, inInclusiveRange(0.06, 0.94));
          expect(point.y, inInclusiveRange(0.06, 0.94));
        }
      }
    });

    test('pas de chevauchement flagrant', () {
      final ids = idsOf(30);
      final points = ConstellationLayout.positions(ids, ringOf(ids));
      var closest = double.infinity;

      for (var i = 0; i < ids.length; i++) {
        for (var j = i + 1; j < ids.length; j++) {
          closest = math.min(
            closest,
            distance(points[ids[i]]!, points[ids[j]]!),
          );
        }
      }

      expect(closest, greaterThan(0.02));
    });

    test('deux liés sont plus proches que deux non liés en moyenne', () {
      final ids = idsOf(12);
      final links = [
        for (var i = 0; i < 4; i++)
          ConstellationLink(
            fromId: ids[i],
            toId: ids[(i + 1) % 4],
            sharedGenres: 2,
          ),
      ];
      final points = ConstellationLayout.positions(ids, links);
      final linked = distance(points[ids[0]]!, points[ids[1]]!);
      final far = ids
          .skip(4)
          .map((id) => distance(points[ids[0]]!, points[id]!))
          .reduce((a, b) => a + b);

      expect(linked, lessThan(far / 8));
    });

    test('ignore les liens vers des ids inconnus ou bouclés', () {
      final points = ConstellationLayout.positions(
        const [1, 2],
        const [
          ConstellationLink(fromId: 1, toId: 99, sharedGenres: 1),
          ConstellationLink(fromId: 2, toId: 2, sharedGenres: 1),
        ],
      );

      expect(points, hasLength(2));
    });

    test('ids dupliqués comptés une seule fois', () {
      expect(
        ConstellationLayout.positions(const [4, 4, 5], const []),
        hasLength(2),
      );
    });

    test('moins de 50 ms pour 100 animes', () {
      final ids = idsOf(100);
      final links = ringOf(ids);
      ConstellationLayout.positions(idsOf(20), const []);

      var best = const Duration(days: 1);

      for (var run = 0; run < 5; run++) {
        final watch = Stopwatch()..start();
        ConstellationLayout.positions(ids, links);
        watch.stop();

        if (watch.elapsed < best) {
          best = watch.elapsed;
        }
      }

      expect(best.inMilliseconds, lessThan(50));
    });
  });
}
