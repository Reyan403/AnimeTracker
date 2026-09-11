import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/catalogue_anime.dart';
import 'package:monapp/layers/functional/Catalogue/domain/use_cases/browse_catalogue_use_case.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/catalogue_cubit.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/catalogue_state.dart';

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

CatalogueCubit cubitOn(FakeAnimeCatalogueGateway gateway) =>
    CatalogueCubit(BrowseCatalogueUseCase(gateway));

Future<void> letTypingSettle() =>
    Future<void>.delayed(CatalogueCubit.typingPause * 2);

void main() {
  test('it opens on the most popular animes', () async {
    final cubit = cubitOn(FakeAnimeCatalogueGateway(mostPopular: const [bebop]));

    await cubit.load();

    expect(cubit.state.status, CatalogueStatus.success);
    expect(cubit.state.animes, [bebop]);
  });

  test('a typed query is searched once typing pauses', () async {
    final cubit = cubitOn(
      FakeAnimeCatalogueGateway(
        mostPopular: const [bebop],
        resultsByQuery: const {
          'frieren': [frieren],
        },
      ),
    );

    cubit.search('frieren');
    expect(cubit.state.status, CatalogueStatus.loading);

    await letTypingSettle();

    expect(cubit.state.animes, [frieren]);
    expect(cubit.state.query, 'frieren');
  });

  test('typing letter by letter only sends the last query', () async {
    final gateway = FakeAnimeCatalogueGateway(
      resultsByQuery: const {
        'frieren': [frieren],
      },
    );
    final cubit = cubitOn(gateway);

    cubit
      ..search('fri')
      ..search('frie')
      ..search('frieren');
    await letTypingSettle();

    expect(gateway.receivedQueries, ['frieren']);
  });

  test('a search without match reports an empty catalogue', () async {
    final cubit = cubitOn(FakeAnimeCatalogueGateway());

    cubit.search('introuvable');
    await letTypingSettle();

    expect(cubit.state.status, CatalogueStatus.empty);
  });

  test('clearing the field brings the popular animes back', () async {
    final cubit = cubitOn(FakeAnimeCatalogueGateway(mostPopular: const [bebop]));

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
}
