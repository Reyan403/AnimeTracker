import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/catalogue_anime.dart';
import 'package:monapp/layers/functional/Catalogue/domain/use_cases/browse_catalogue_use_case.dart';

import 'fake_anime_catalogue_gateway.dart';

const bebop = CatalogueAnime(
  id: 1,
  title: 'Cowboy Bebop',
  format: 'TV',
  year: 1998,
  episodeCount: 26,
);

const mob = CatalogueAnime(
  id: 32182,
  title: 'Mob Psycho 100',
  format: 'TV',
  year: 2016,
  episodeCount: 12,
);

const frieren = CatalogueAnime(
  id: 52991,
  title: 'Sousou no Frieren',
  format: 'TV',
  year: 2023,
  episodeCount: 28,
);

FakeAnimeCatalogueGateway gateway() => FakeAnimeCatalogueGateway(
      mostPopular: const [bebop, mob],
      resultsByQuery: const {
        'frieren': [frieren],
      },
      pageSize: 1,
    );

void main() {
  test('an empty query browses the most popular animes', () async {
    final fake = gateway();

    final page = await BrowseCatalogueUseCase(fake)('');

    expect(page.animes, [bebop]);
    expect(fake.receivedQueries, ['']);
  });

  test('a query shorter than three letters keeps the popular list', () async {
    final fake = gateway();

    expect((await BrowseCatalogueUseCase(fake)('fr')).animes, [bebop]);
    expect(fake.receivedQueries, ['']);
  });

  test('a longer query is searched once trimmed', () async {
    final fake = gateway();

    expect((await BrowseCatalogueUseCase(fake)('  frieren ')).animes, [frieren]);
    expect(fake.receivedQueries, ['frieren']);
  });

  test('it browses the first page unless another one is asked', () async {
    final fake = gateway();

    await BrowseCatalogueUseCase(fake)('');
    await BrowseCatalogueUseCase(fake)('', page: 2);

    expect(fake.receivedPages, [1, 2]);
  });

  test('a page announces whether another one follows', () async {
    final useCase = BrowseCatalogueUseCase(gateway());

    expect((await useCase('')).hasMore, isTrue);
    expect((await useCase('', page: 2)).hasMore, isFalse);
  });

  test('a page beyond the last one comes back empty', () async {
    final page = await BrowseCatalogueUseCase(gateway())('', page: 3);

    expect(page.animes, isEmpty);
    expect(page.hasMore, isFalse);
  });
}
