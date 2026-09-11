import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/catalogue_anime.dart';
import 'package:monapp/layers/functional/Catalogue/domain/use_cases/browse_catalogue_use_case.dart';

import 'fake_anime_catalogue_gateway.dart';

const bebop = CatalogueAnime(
  malId: 1,
  title: 'Cowboy Bebop',
  studio: 'Sunrise',
  year: 1998,
  episodeCount: 26,
);

const frieren = CatalogueAnime(
  malId: 52991,
  title: 'Sousou no Frieren',
  studio: 'Madhouse',
  year: 2023,
  episodeCount: 28,
);

FakeAnimeCatalogueGateway gateway() => FakeAnimeCatalogueGateway(
      mostPopular: const [bebop],
      resultsByQuery: const {
        'frieren': [frieren],
      },
    );

void main() {
  test('an empty query browses the most popular animes', () async {
    final fake = gateway();

    expect(await BrowseCatalogueUseCase(fake)(''), [bebop]);
    expect(fake.receivedQueries, ['']);
  });

  test('a query shorter than three letters keeps the popular list', () async {
    final fake = gateway();

    expect(await BrowseCatalogueUseCase(fake)('fr'), [bebop]);
    expect(fake.receivedQueries, ['']);
  });

  test('a longer query is searched once trimmed', () async {
    final fake = gateway();

    expect(await BrowseCatalogueUseCase(fake)('  frieren '), [frieren]);
    expect(fake.receivedQueries, ['frieren']);
  });

  test('a search without match comes back empty', () async {
    expect(await BrowseCatalogueUseCase(gateway())('introuvable'), isEmpty);
  });
}
