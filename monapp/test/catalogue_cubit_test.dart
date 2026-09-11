import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/catalogue_anime.dart';
import 'package:monapp/layers/functional/Catalogue/domain/use_cases/browse_catalogue_use_case.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/catalogue_cubit.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/catalogue_state.dart';

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

FakeAnimeCatalogueGateway pagedGateway() => FakeAnimeCatalogueGateway(
      mostPopular: const [bebop, mob],
      resultsByQuery: const {
        'frieren': [frieren],
      },
      pageSize: 1,
    );

CatalogueCubit cubitOn(FakeAnimeCatalogueGateway gateway) =>
    CatalogueCubit(BrowseCatalogueUseCase(gateway));

Future<void> letTypingSettle() =>
    Future<void>.delayed(CatalogueCubit.typingPause * 2);

void main() {
  test('it opens on the most popular animes', () async {
    final cubit = cubitOn(pagedGateway());

    await cubit.load();

    expect(cubit.state.status, CatalogueStatus.success);
    expect(cubit.state.animes, [bebop]);
    expect(cubit.state.hasMore, isTrue);
  });

  test('a typed query is searched once typing pauses', () async {
    final cubit = cubitOn(pagedGateway());

    cubit.search('frieren');
    expect(cubit.state.status, CatalogueStatus.loading);

    await letTypingSettle();

    expect(cubit.state.animes, [frieren]);
    expect(cubit.state.query, 'frieren');
  });

  test('typing letter by letter only sends the last query', () async {
    final gateway = pagedGateway();
    final cubit = cubitOn(gateway);

    cubit
      ..search('fri')
      ..search('frie')
      ..search('frieren');
    await letTypingSettle();

    expect(gateway.receivedQueries, ['frieren']);
  });

  test('asking for more appends the next page', () async {
    final gateway = pagedGateway();
    final cubit = cubitOn(gateway);

    await cubit.load();
    await cubit.loadMore();

    expect(cubit.state.animes, [bebop, mob]);
    expect(gateway.receivedPages, [1, 2]);
  });

  test('the last page stops the browsing', () async {
    final gateway = pagedGateway();
    final cubit = cubitOn(gateway);

    await cubit.load();
    await cubit.loadMore();

    expect(cubit.state.hasMore, isFalse);

    await cubit.loadMore();

    expect(gateway.receivedPages, [1, 2]);
  });

  test('a new search starts the pages over', () async {
    final gateway = pagedGateway();
    final cubit = cubitOn(gateway);

    await cubit.load();
    await cubit.loadMore();
    cubit.search('frieren');
    await letTypingSettle();

    expect(cubit.state.animes, [frieren]);
    expect(cubit.state.page, BrowseCatalogueUseCase.firstPage);
    expect(gateway.receivedPages, [1, 2, 1]);
  });

  test('a search without match reports an empty catalogue', () async {
    final cubit = cubitOn(FakeAnimeCatalogueGateway());

    cubit.search('introuvable');
    await letTypingSettle();

    expect(cubit.state.status, CatalogueStatus.empty);
  });

  test('clearing the field brings the popular animes back', () async {
    final cubit = cubitOn(pagedGateway());

    cubit.search('frieren');
    await letTypingSettle();
    await cubit.clear();

    expect(cubit.state.query, '');
    expect(cubit.state.animes, [bebop]);
  });

  test('an unreachable service leaves the catalogue in failure', () async {
    final cubit = cubitOn(FakeAnimeCatalogueGateway(isDown: true));

    await cubit.load();

    expect(cubit.state.status, CatalogueStatus.failure);
  });

  test('a page that fails to load keeps what is already shown', () async {
    final cubit = cubitOn(
      FakeAnimeCatalogueGateway(
        mostPopular: const [bebop, mob],
        pageSize: 1,
        failingPage: 2,
      ),
    );

    await cubit.load();
    await cubit.loadMore();

    expect(cubit.state.animes, [bebop]);
    expect(cubit.state.isAppending, isFalse);
    expect(cubit.state.hasMore, isFalse);
  });

  test('a page that repeats what is shown adds nothing', () async {
    final cubit = cubitOn(
      FakeAnimeCatalogueGateway(
        mostPopular: const [bebop, mob],
        pageSize: 1,
        repeatsPages: true,
      ),
    );

    await cubit.load();
    await cubit.loadMore();

    expect(cubit.state.animes, [bebop]);
    expect(cubit.state.page, 2);
  });
}
