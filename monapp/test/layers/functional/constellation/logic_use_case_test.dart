import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Constellation/domain/use_cases/build_constellation_use_case.dart';

import '../../../support/watchlist_fixtures.dart';
import 'star_logic_support.dart';

void main() {
  group('BuildConstellationUseCase', () {
    test('une liste vide donne une constellation vide', () async {
      final constellation = await built(const [], const {});

      expect(constellation.stars, isEmpty);
      expect(constellation.links, isEmpty);
      expect(constellation.genres, isEmpty);
    });

    test('un seul anime sans genre donne une étoile centrée', () async {
      final constellation = await built(
        const [
          WatchlistEntry(id: 9, title: 'Seul', status: WatchStatus.toWatch),
        ],
        {9: detailsOf()},
      );

      expect(constellation.stars, hasLength(1));
      expect(constellation.stars.single.x, 0.5);
      expect(constellation.stars.single.y, 0.5);
      expect(constellation.stars.single.genreSlug, isNull);
      expect(constellation.links, isEmpty);
    });

    test('échoue sans aucun détail', () {
      expect(
        useCaseOf(entries, const {}, fails: true)(),
        emitsError(isA<ConstellationUnavailableException>()),
      );
    });

    test('exception lisible', () {
      expect(
        const ConstellationUnavailableException().toString(),
        contains('unavailable'),
      );
    });

    test('attend la fin du chargement des détails', () async {
      final first = await built(entries, {
        1: detailsOf(genres: ['action']),
        2: detailsOf(genres: ['action']),
        3: detailsOf(genres: ['action']),
      });

      expect(first.stars, hasLength(3));
      expect(first.stars.every((star) => star.genreSlug == 'action'), isTrue);
    });

    test('les positions sont dans les marges et stables', () async {
      final details = {
        for (final id in [1, 2, 3]) id: detailsOf(genres: ['a']),
      };
      final one = await built(entries, details);
      final two = await built(entries, details);

      expect(one.stars, two.stars);
      for (final star in one.stars) {
        expect(star.x, inInclusiveRange(0.06, 0.94));
        expect(star.y, inInclusiveRange(0.06, 0.94));
      }
    });

    test('garde un anime sans détail comme étoile sans genre', () async {
      final constellation = await built(entries, {
        1: detailsOf(genres: ['action']),
        2: detailsOf(genres: ['action']),
      });
      final orphan = constellation.stars.firstWhere(
        (star) => star.animeId == 3,
      );

      expect(constellation.stars, hasLength(3));
      expect(orphan.genreSlug, isNull);
      expect(orphan.posterUrl, isNull);
    });

    test('reprend titre, statut et affiche de chaque anime', () async {
      final constellation = await built(entries, {
        1: const AnimeDetails(
          format: 'TV',
          year: 2020,
          episodeCount: 12,
          posterUrl: 'https://img/1.jpg',
        ),
        2: detailsOf(),
        3: detailsOf(),
      });
      final first = constellation.stars.firstWhere((star) => star.animeId == 1);

      expect(first.title, 'Terminé');
      expect(first.status, WatchStatus.completed);
      expect(first.posterUrl, 'https://img/1.jpg');
    });
  });
}
