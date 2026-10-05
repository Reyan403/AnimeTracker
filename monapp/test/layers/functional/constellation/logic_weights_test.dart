import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Constellation/domain/use_cases/build_constellation_use_case.dart';

import '../../../support/watchlist_fixtures.dart';
import 'star_logic_support.dart';

void main() {
  group('pondération', () {
    test(
      'un anime à voir est le plus petit, un terminé le plus grand',
      () async {
        final constellation = await built(entries, {
          1: detailsOf(),
          2: detailsOf(),
          3: detailsOf(),
        });
        double weight(int id) =>
            constellation.stars.firstWhere((star) => star.animeId == id).weight;

        expect(weight(3), BuildConstellationUseCase.toWatchWeight);
        expect(weight(1), BuildConstellationUseCase.completedWeight);
        expect(weight(2), greaterThan(weight(3)));
        expect(weight(2), lessThan(weight(1)));
      },
    );

    test('le poids en cours croît avec la progression', () async {
      const list = [
        WatchlistEntry(
          id: 1,
          title: 'Début',
          status: WatchStatus.watching,
          episodesWatched: 1,
        ),
        WatchlistEntry(
          id: 2,
          title: 'Milieu',
          status: WatchStatus.watching,
          episodesWatched: 6,
        ),
        WatchlistEntry(
          id: 3,
          title: 'Fin',
          status: WatchStatus.watching,
          episodesWatched: 11,
        ),
        WatchlistEntry(id: 4, title: 'Zéro', status: WatchStatus.watching),
      ];
      final constellation = await built(list, {
        for (final id in [1, 2, 3, 4]) id: detailsOf(),
      });
      final weights = [
        for (final id in [4, 1, 2, 3])
          constellation.stars.firstWhere((star) => star.animeId == id).weight,
      ];

      expect(weights.first, BuildConstellationUseCase.watchingBaseWeight);
      expect(weights, orderedEquals([...weights]..sort()));
      expect(weights.toSet(), hasLength(4));
      expect(weights.every((weight) => weight >= 0.55 && weight <= 1), isTrue);
    });
  });

  group('genres', () {
    final details = {
      1: detailsOf(genres: ['action', 'drama']),
      2: detailsOf(genres: ['action', 'comedy']),
      3: detailsOf(genres: ['action', 'comedy']),
      4: detailsOf(genres: ['drama']),
    };
    const list = [
      WatchlistEntry(id: 1, title: 'A', status: WatchStatus.completed),
      WatchlistEntry(id: 2, title: 'B', status: WatchStatus.completed),
      WatchlistEntry(id: 3, title: 'C', status: WatchStatus.toWatch),
      WatchlistEntry(id: 4, title: 'D', status: WatchStatus.completed),
    ];

    test('ordonne par fréquence puis alphabétique', () async {
      final constellation = await built(list, details);

      expect(constellation.genres.map((genre) => genre.slug), [
        'action',
        'comedy',
        'drama',
      ]);
    });

    test('le genre principal est le plus fréquent de la liste', () async {
      final constellation = await built(list, details);
      String? main(int id) => constellation.stars
          .firstWhere((star) => star.animeId == id)
          .genreSlug;

      expect(main(1), 'action');
      expect(main(2), 'action');
      expect(main(4), 'drama');
    });

    test('à égalité, le genre principal est alphabétique', () async {
      final constellation = await built(
        const [
          WatchlistEntry(id: 1, title: 'A', status: WatchStatus.completed),
        ],
        {
          1: detailsOf(genres: ['romance', 'comedy']),
        },
      );

      expect(constellation.stars.single.genreSlug, 'comedy');
    });
  });
}
