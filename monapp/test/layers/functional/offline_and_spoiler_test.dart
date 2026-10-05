import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/data/models/anime_details_cache_dto.dart';
import 'package:monapp/layers/functional/Anime/data/stores/preferences_anime_details_cache.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Anime/domain/use_cases/find_watch_status_use_case.dart';
import 'package:monapp/layers/functional/Anime/presentation/cubit/watchlist_state.dart';
import 'package:monapp/layers/functional/Anime/data/gateways/local_watchlist_gateway.dart';
import 'package:monapp/layers/functional/Catalogue/data/models/anime_sheet_cache_dto.dart';
import 'package:monapp/layers/functional/Catalogue/data/stores/preferences_anime_sheet_cache.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/anime_sheet.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/anime_catalogue_gateway.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/anime_sheet_gateway.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/french_synopsis_gateway.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/synopsis_translation_gateway.dart';
import 'package:monapp/layers/functional/Catalogue/domain/use_cases/load_anime_sheet_use_case.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/anime_sheet_cubit.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/anime_sheet_state.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/widgets/anime_sheet_body.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/widgets/hidden_synopsis.dart';
import 'package:monapp/layers/functional/Settings/data/preferences_settings_gateway.dart';
import 'package:monapp/layers/functional/Settings/domain/gateways/settings_gateway.dart';
import 'package:monapp/layers/functional/Settings/domain/use_cases/change_spoiler_guard_use_case.dart';
import 'package:monapp/layers/functional/Settings/domain/use_cases/read_spoiler_guard_use_case.dart';
import 'package:monapp/layers/functional/Settings/presentation/cubit/settings_cubit.dart';
import 'package:monapp/layers/functional/Settings/presentation/widgets/spoiler_guard_switch.dart';
import 'package:monapp/layers/technical/Preferences/app_preferences.dart';
import 'package:monapp/layers/technical/Theme/widgets/offline_notice.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../../support/fake_caches.dart';
import '../../support/fake_watchlist_store.dart';
import '../../support/pump_app.dart';
import '../../support/watchlist_fixtures.dart';

const sheet = AnimeSheet(
  id: 1,
  title: 'Monster',
  format: 'Série TV',
  synopsis: 'Un chirurgien poursuit un tueur.',
  rating: 88,
  startYear: 2004,
);

class FakeSheetGateway implements AnimeSheetGateway {
  FakeSheetGateway({this.fails = false});

  bool fails;

  @override
  Future<AnimeSheet> findById(int id) async {
    if (fails) {
      throw const CatalogueUnavailableException();
    }

    return sheet;
  }
}

class FakeFrenchGateway implements FrenchSynopsisGateway {
  FakeFrenchGateway([this.synopsis]);

  final String? synopsis;

  @override
  Future<String?> findFor(String title) async => synopsis;
}

class FakeTranslationGateway implements SynopsisTranslationGateway {
  FakeTranslationGateway([this.translation]);

  final String? translation;

  @override
  Future<String?> translateToFrench(String text) async => translation;
}

class FakeSettingsGateway implements SettingsGateway {
  FakeSettingsGateway({this.isSpoilerGuardEnabled = true});

  @override
  bool isSpoilerGuardEnabled;

  @override
  void changeSpoilerGuard({required bool enabled}) =>
      isSpoilerGuardEnabled = enabled;
}

AnimeSheetCubit sheetCubit({
  WatchStatus? status,
  bool guard = true,
  FakeSheetGateway? gateway,
}) {
  final watchlist = LocalWatchlistGateway(
    FakeWatchlistStore([
      if (status != null)
        WatchlistEntry(id: 1, title: 'Monster', status: status),
    ]),
    const [],
  );
  final cubit = AnimeSheetCubit(
    LoadAnimeSheetUseCase(
      gateway ?? FakeSheetGateway(),
      FakeFrenchGateway(),
      FakeTranslationGateway(),
      FakeSheetCache(),
    ),
    FindWatchStatusUseCase(watchlist),
    ReadSpoilerGuardUseCase(FakeSettingsGateway(isSpoilerGuardEnabled: guard)),
  );
  addTearDown(cubit.close);

  return cubit;
}

Future<AnimeSheet> lastOf(Stream<AnimeSheet> sheets) async =>
    (await sheets.toList()).last;

void main() {
  group('hors ligne : détails de la liste', () {
    const entries = [
      WatchlistEntry(id: 1, title: 'A', status: WatchStatus.watching),
    ];

    test('une récupération réussie alimente le cache', () async {
      final cache = FakeDetailsCache();
      final animes = await watchlistOf(
        entries,
        {1: detailsOf()},
        cache: cache,
      )()
          .firstWhere((list) => list.every((anime) => !anime.isLoadingDetails));

      expect(animes.single.details?.isCached, isFalse);
      expect(cache.saves, 1);
      expect(cache.stored.containsKey(1), isTrue);
    });

    test('un échec réseau utilise les données enregistrées', () async {
      final animes = await watchlistOf(
        entries,
        const {},
        fails: true,
        cache: FakeDetailsCache({1: detailsOf(episodes: 24)}),
      )()
          .firstWhere((list) => list.every((anime) => !anime.isLoadingDetails));

      expect(animes.single.details?.isCached, isTrue);
      expect(animes.single.totalEpisodes, 24);
    });

    test('sans cache, les détails restent absents', () async {
      final animes = await watchlistOf(entries, const {}, fails: true)()
          .firstWhere((list) => list.every((anime) => !anime.isLoadingDetails));

      expect(animes.single.details, isNull);
    });

    test('l état de liste signale l usage du cache', () {
      final cached = detailsOf().asCached();

      expect(cached.isCached, isTrue);
      expect(const WatchlistState().isShowingCache, isFalse);
    });
  });

  group('hors ligne : fiches', () {
    LoadAnimeSheetUseCase useCase(
      FakeSheetGateway gateway,
      FakeSheetCache cache, {
      String? french,
    }) =>
        LoadAnimeSheetUseCase(
          gateway,
          FakeFrenchGateway(french),
          FakeTranslationGateway(),
          cache,
        );

    test('une fiche chargée est enregistrée avec son synopsis français',
        () async {
      final cache = FakeSheetCache();

      final loaded = await lastOf(
        useCase(FakeSheetGateway(), cache, french: 'Résumé français')(1),
      );

      expect(loaded.isCached, isFalse);
      expect(cache.stored[1]?.synopsis, 'Résumé français');
    });

    test('un échec réseau renvoie la fiche enregistrée', () async {
      final loaded = await lastOf(
        useCase(
          FakeSheetGateway(fails: true),
          FakeSheetCache({1: sheet}),
        )(1),
      );

      expect(loaded.isCached, isTrue);
      expect(loaded.title, 'Monster');
    });

    test('un échec sans fiche enregistrée relance l erreur', () {
      expect(
        useCase(FakeSheetGateway(fails: true), FakeSheetCache())(1).toList(),
        throwsA(isA<CatalogueUnavailableException>()),
      );
    });
  });

  group('persistance des caches', () {
    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
    });

    test('les détails survivent à la réouverture', () async {
      final first = PreferencesAnimeDetailsCache(await AppPreferences.open());
      first.saveAll({1: detailsOf(episodes: 12, genres: ['action'])});

      await Future<void>.delayed(Duration.zero);

      final reopened =
          PreferencesAnimeDetailsCache(await AppPreferences.open());
      final found = reopened.findAll([1, 2]);

      expect(found.keys, [1]);
      expect(found[1]?.isCached, isTrue);
      expect(found[1]?.hasGenre('action'), isTrue);
    });

    test('le DTO de détails fait l aller-retour', () {
      final details = detailsOf(genres: ['drama']);
      final restored = AnimeDetailsCacheDto.fromJson(
        AnimeDetailsCacheDto.toJson(details),
      );

      expect(restored.episodeCount, details.episodeCount);
      expect(restored.episodeMinutes, details.episodeMinutes);
      expect(restored.genres.single.slug, 'drama');
    });

    test('une fiche survit à la réouverture', () async {
      final first = PreferencesAnimeSheetCache(await AppPreferences.open());
      first.save(sheet);

      await Future<void>.delayed(Duration.zero);

      final reopened = PreferencesAnimeSheetCache(await AppPreferences.open());

      expect(reopened.find(1)?.title, 'Monster');
      expect(reopened.find(1)?.isCached, isTrue);
      expect(reopened.find(2), isNull);
    });

    test('les fiches les plus anciennes sont écartées', () async {
      final cache = PreferencesAnimeSheetCache(await AppPreferences.open());

      for (var id = 1; id <= PreferencesAnimeSheetCache.capacity + 2; id++) {
        cache.save(
          AnimeSheet(id: id, title: 'A$id', format: 'TV'),
        );
      }

      expect(cache.find(1), isNull);
      expect(cache.find(2), isNull);
      expect(cache.find(PreferencesAnimeSheetCache.capacity + 2), isNotNull);
    });

    test('le DTO de fiche fait l aller-retour', () {
      final restored = AnimeSheetCacheDto.fromJson(
        AnimeSheetCacheDto.toJson(sheet),
      );

      expect(restored.synopsis, sheet.synopsis);
      expect(restored.rating, 88);
      expect(restored.startYear, 2004);
    });

    test('le réglage anti-spoil est conservé', () async {
      final gateway = PreferencesSettingsGateway(await AppPreferences.open());

      expect(gateway.isSpoilerGuardEnabled, isTrue);

      gateway.changeSpoilerGuard(enabled: false);
      await Future<void>.delayed(Duration.zero);

      expect(
        PreferencesSettingsGateway(await AppPreferences.open())
            .isSpoilerGuardEnabled,
        isFalse,
      );
    });
  });

  group('AnimeSheetCubit anti-spoil', () {
    test('masque le synopsis d un anime en cours', () async {
      final cubit = sheetCubit(status: WatchStatus.watching);

      await cubit.load(1);

      expect(cubit.state.isSynopsisHidden, isTrue);
    });

    test('masque le synopsis d un anime à voir', () async {
      final cubit = sheetCubit(status: WatchStatus.toWatch);

      await cubit.load(1);

      expect(cubit.state.isSynopsisHidden, isTrue);
    });

    test('laisse visible un anime terminé', () async {
      final cubit = sheetCubit(status: WatchStatus.completed);

      await cubit.load(1);

      expect(cubit.state.isSynopsisHidden, isFalse);
    });

    test('masque le synopsis d un anime du catalogue absent de la liste',
        () async {
      final cubit = sheetCubit();

      await cubit.load(1);

      expect(cubit.state.isSynopsisHidden, isTrue);
    });

    test('laisse visible quand la protection est désactivée', () async {
      final cubit = sheetCubit(status: WatchStatus.watching, guard: false);

      await cubit.load(1);

      expect(cubit.state.isSynopsisHidden, isFalse);
    });

    test('révéler le synopsis le rend lisible', () async {
      final cubit = sheetCubit(status: WatchStatus.watching);

      await cubit.load(1);
      cubit.revealSynopsis();

      expect(cubit.state.isSynopsisHidden, isFalse);
      expect(cubit.state.sheet, isNotNull);
    });

    test('signale un échec de chargement', () async {
      final cubit = sheetCubit(gateway: FakeSheetGateway(fails: true));

      await cubit.load(1);

      expect(cubit.state.status, AnimeSheetStatus.failure);
    });
  });

  group('SettingsCubit', () {
    test('lit puis change le réglage', () {
      final gateway = FakeSettingsGateway();
      final cubit = SettingsCubit(
        ReadSpoilerGuardUseCase(gateway),
        ChangeSpoilerGuardUseCase(gateway),
      );
      addTearDown(cubit.close);

      expect(cubit.state.isSpoilerGuardEnabled, isTrue);

      cubit.changeSpoilerGuard(enabled: false);

      expect(cubit.state.isSpoilerGuardEnabled, isFalse);
      expect(gateway.isSpoilerGuardEnabled, isFalse);
    });

    testWidgets('l interrupteur reflète et modifie le réglage', (tester) async {
      final gateway = FakeSettingsGateway();
      final cubit = SettingsCubit(
        ReadSpoilerGuardUseCase(gateway),
        ChangeSpoilerGuardUseCase(gateway),
      );
      addTearDown(cubit.close);

      await pumpApp(
        tester,
        BlocProvider.value(value: cubit, child: const SpoilerGuardSwitch()),
      );

      expect(find.text('Masquer les spoilers'), findsOneWidget);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(gateway.isSpoilerGuardEnabled, isFalse);
    });
  });

  group('widgets', () {
    testWidgets('le synopsis flouté se révèle au toucher', (tester) async {
      var revealed = false;

      await pumpApp(
        tester,
        HiddenSynopsis(
          synopsis: 'Texte secret',
          onReveal: () => revealed = true,
        ),
      );

      expect(find.text('Synopsis masqué pour éviter les spoilers.'),
          findsOneWidget);

      await tester.tap(find.text('Afficher'));

      expect(revealed, isTrue);
    });

    testWidgets('la fiche masque le synopsis quand demandé', (tester) async {
      await pumpApp(
        tester,
        const AnimeSheetBody(
          sheet: sheet,
          heroTag: 'poster-test-1',
          isSynopsisHidden: true,
        ),
        size: const Size(500, 1400),
      );

      expect(find.byType(HiddenSynopsis), findsOneWidget);
    });

    testWidgets('la fiche affiche le bandeau hors ligne', (tester) async {
      await pumpApp(
        tester,
        AnimeSheetBody(sheet: sheet.asCached(), heroTag: 'poster-test-1'),
        size: const Size(500, 1400),
      );

      expect(find.byType(OfflineNotice), findsOneWidget);
      expect(find.byType(HiddenSynopsis), findsNothing);
    });

    testWidgets('la fiche en ligne n affiche pas le bandeau', (tester) async {
      await pumpApp(
        tester,
        const AnimeSheetBody(sheet: sheet, heroTag: 'poster-test-1'),
        size: const Size(500, 1400),
      );

      expect(find.byType(OfflineNotice), findsNothing);
      expect(find.text('Un chirurgien poursuit un tueur.'), findsOneWidget);
    });
  });
}
