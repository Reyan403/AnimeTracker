import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Constellation/domain/entities/constellation_link.dart';
import 'package:monapp/layers/functional/Constellation/domain/use_cases/constellation_links_builder.dart';

import '../../../support/watchlist_fixtures.dart';

Anime animeOf(int id, List<String> genres) => Anime(
  id: id,
  title: 'Anime $id',
  status: WatchStatus.completed,
  details: detailsOf(genres: genres),
);

Map<int, int> degreesOf(List<ConstellationLink> links) {
  final degrees = <int, int>{};

  for (final link in links) {
    degrees.update(link.fromId, (count) => count + 1, ifAbsent: () => 1);
    degrees.update(link.toId, (count) => count + 1, ifAbsent: () => 1);
  }

  return degrees;
}

void main() {
  group('ConstellationLinksBuilder', () {
    test('relie les animes qui partagent un genre', () {
      final links = ConstellationLinksBuilder.build([
        animeOf(1, ['action']),
        animeOf(2, ['action', 'drama']),
        animeOf(3, ['horror']),
      ]);

      expect(links, hasLength(1));
      expect(links.single.fromId, 1);
      expect(links.single.toId, 2);
      expect(links.single.sharedGenres, 1);
    });

    test('compte les genres partagés', () {
      final links = ConstellationLinksBuilder.build([
        animeOf(1, ['action', 'drama', 'comedy']),
        animeOf(2, ['drama', 'action']),
      ]);

      expect(links.single.sharedGenres, 2);
    });

    test('aucun lien sans genre ni détail', () {
      final links = ConstellationLinksBuilder.build([
        animeOf(1, const []),
        animeOf(2, const []),
        const Anime(id: 3, title: 'Sans détail', status: WatchStatus.toWatch),
      ]);

      expect(links, isEmpty);
    });

    test('au plus trois liens par étoile', () {
      final links = ConstellationLinksBuilder.build([
        for (var id = 1; id <= 20; id++) animeOf(id, ['action']),
      ]);

      expect(links, isNotEmpty);
      expect(degreesOf(links).values.every((degree) => degree <= 3), isTrue);
    });

    test('pas de doublon et fromId inférieur à toId', () {
      final links = ConstellationLinksBuilder.build([
        for (var id = 1; id <= 15; id++) animeOf(id, ['action', 'drama']),
      ]);
      final pairs = links.map((link) => '${link.fromId}-${link.toId}');

      expect(pairs.toSet(), hasLength(links.length));
      expect(links.every((link) => link.fromId < link.toId), isTrue);
    });

    test('garde les liens les plus forts', () {
      final links = ConstellationLinksBuilder.build([
        animeOf(1, ['a', 'b', 'c']),
        animeOf(2, ['a', 'b', 'c']),
        for (var id = 3; id <= 8; id++) animeOf(id, ['a']),
      ]);
      final strong = links.firstWhere(
        (link) => link.fromId == 1 && link.toId == 2,
      );

      expect(strong.sharedGenres, 3);
    });

    test("même résultat quel que soit l'ordre de la liste", () {
      final animes = [
        for (var id = 1; id <= 25; id++)
          animeOf(id, id.isEven ? ['action', 'drama'] : ['action']),
      ];

      expect(
        ConstellationLinksBuilder.build(animes.reversed.toList()),
        ConstellationLinksBuilder.build(animes),
      );
    });
  });
}
