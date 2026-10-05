import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/l10n/app_localizations.dart';
import 'package:monapp/layers/functional/Anime/data/models/anime_details_dto.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Anime/presentation/anime_genre_label.dart';
import 'package:monapp/layers/functional/Discover/domain/entities/evening_duration.dart';
import 'package:monapp/layers/functional/Discover/domain/entities/evening_mood.dart';
import 'package:monapp/layers/functional/Discover/domain/use_cases/suggest_evening_watch_use_case.dart';
import 'package:monapp/layers/functional/Discover/presentation/cubit/evening_cubit.dart';
import 'package:monapp/layers/functional/Discover/presentation/cubit/evening_state.dart';
import 'package:monapp/layers/functional/Discover/presentation/widgets/evening_section.dart';

import '../../support/pump_app.dart';
import '../../support/watchlist_fixtures.dart';

const entries = [
  WatchlistEntry(id: 1, title: 'Comédie courte', status: WatchStatus.toWatch),
  WatchlistEntry(id: 2, title: 'Action longue', status: WatchStatus.watching),
  WatchlistEntry(id: 3, title: 'Drame fini', status: WatchStatus.completed),
  WatchlistEntry(id: 4, title: 'Sans durée', status: WatchStatus.toWatch),
];

SuggestEveningWatchUseCase useCase({int seed = 1}) =>
    SuggestEveningWatchUseCase(
      watchlistOf(entries, {
        1: detailsOf(minutes: 12, genres: ['comedy']),
        2: detailsOf(minutes: 45, genres: ['action']),
        3: detailsOf(genres: ['drama']),
        4: detailsOf(minutes: 0, genres: ['mystery']),
      }),
      random: Random(seed),
    );

void main() {
  group('SuggestEveningWatchUseCase', () {
    test('filtre par humeur', () async {
      final suggestion = await useCase()(
        mood: EveningMood.action,
        duration: EveningDuration.unlimited,
      );

      expect(suggestion?.anime.id, 2);
      expect(suggestion?.matchedGenres.single.slug, 'action');
      expect(suggestion?.isContinuing, isTrue);
    });

    test('filtre par durée', () async {
      final suggestion = await useCase()(
        mood: EveningMood.action,
        duration: EveningDuration.short,
      );

      expect(suggestion, isNull);
    });

    test('garde un anime à durée inconnue', () async {
      final suggestion = await useCase()(
        mood: EveningMood.mystery,
        duration: EveningDuration.short,
      );

      expect(suggestion?.anime.id, 4);
      expect(suggestion?.isContinuing, isFalse);
    });

    test('ne propose jamais un anime terminé', () async {
      for (var seed = 0; seed < 20; seed++) {
        final suggestion = await useCase(seed: seed)(
          mood: EveningMood.any,
          duration: EveningDuration.unlimited,
        );

        expect(suggestion?.anime.id, isNot(3));
      }
    });

    test('exclut les suggestions déjà montrées', () async {
      final suggestion = await useCase()(
        mood: EveningMood.relaxed,
        duration: EveningDuration.unlimited,
        excludedIds: {1},
      );

      expect(suggestion, isNull);
    });

    test('préfère statistiquement les animes en cours', () async {
      var continuing = 0;

      for (var seed = 0; seed < 300; seed++) {
        final suggestion = await useCase(seed: seed)(
          mood: EveningMood.any,
          duration: EveningDuration.unlimited,
        );

        if (suggestion!.isContinuing) {
          continuing++;
        }
      }

      expect(continuing, greaterThan(300 ~/ 4));
    });

    test('échoue sans aucun détail', () {
      final failing = SuggestEveningWatchUseCase(
        watchlistOf(entries, const {}, fails: true),
      );

      expect(
        failing(mood: EveningMood.any, duration: EveningDuration.unlimited),
        throwsA(isA<EveningSuggestionUnavailableException>()),
      );
    });

    test('une liste vide ne donne rien', () async {
      final empty = SuggestEveningWatchUseCase(watchlistOf(const [], const {}));

      expect(
        await empty(mood: EveningMood.any, duration: EveningDuration.long),
        isNull,
      );
    });

    test('exception lisible', () {
      expect(
        const EveningSuggestionUnavailableException().toString(),
        contains('unavailable'),
      );
    });
  });

  group('EveningCubit', () {
    EveningCubit cubit({int seed = 1}) {
      final created = EveningCubit(useCase(seed: seed));
      addTearDown(created.close);

      return created;
    }

    test('suggère puis propose une autre idée', () async {
      final evening = cubit();

      await evening.suggest();
      final first = evening.state.suggestion!.anime.id;

      expect(evening.state.status, EveningStatus.suggested);

      await evening.suggestAnother();

      expect(evening.state.suggestion!.anime.id, isNot(first));
    });

    test('recommence le tirage quand tout a été montré', () async {
      final evening = cubit()..selectMood(EveningMood.action);

      await evening.suggest();
      await evening.suggestAnother();

      expect(evening.state.status, EveningStatus.suggested);
      expect(evening.state.suggestion!.anime.id, 2);
    });

    test('signale l absence de résultat', () async {
      final evening = cubit()
        ..selectMood(EveningMood.action)
        ..selectDuration(EveningDuration.short);

      await evening.suggest();

      expect(evening.state.status, EveningStatus.none);
    });

    test('changer de filtre efface la suggestion', () async {
      final evening = cubit();

      await evening.suggest();
      evening.selectMood(EveningMood.relaxed);

      expect(evening.state.status, EveningStatus.idle);
      expect(evening.state.suggestion, isNull);
      expect(evening.state.mood, EveningMood.relaxed);

      evening.selectDuration(EveningDuration.long);

      expect(evening.state.duration, EveningDuration.long);
    });

    test('signale une erreur', () async {
      final evening = EveningCubit(
        SuggestEveningWatchUseCase(watchlistOf(entries, const {}, fails: true)),
      );
      addTearDown(evening.close);

      await evening.suggest();

      expect(evening.state.status, EveningStatus.failure);
    });
  });

  group('EveningSection', () {
    Future<void> pumpSection(
      WidgetTester tester, {
      void Function(int, String)? onSelected,
    }) async {
      final evening = EveningCubit(useCase());
      addTearDown(evening.close);

      await pumpApp(
        tester,
        BlocProvider.value(
          value: evening,
          child: SingleChildScrollView(
            child: EveningSection(onAnimeSelected: onSelected ?? (_, _) {}),
          ),
        ),
        size: const Size(500, 1400),
      );
    }

    testWidgets('affiche filtres puis suggestion et ouvre la fiche',
        (tester) async {
      int? opened;

      await pumpSection(tester, onSelected: (id, _) => opened = id);

      expect(find.text('Quoi regarder ce soir ?'), findsOneWidget);

      await tester.tap(find.text('Action'));
      await tester.pump();
      await tester.tap(find.text('Surprends-moi'));
      await tester.pumpAndSettle();

      expect(find.text('Action longue'), findsOneWidget);
      expect(find.text('Vous l\'avez commencé : reprenez-le.'), findsOneWidget);

      await tester.tap(find.text('Voir la fiche'));

      expect(opened, 2);
    });

    testWidgets('propose une autre idée', (tester) async {
      await pumpSection(tester);

      await tester.tap(find.text('Surprends-moi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Une autre idée'));
      await tester.pumpAndSettle();

      expect(find.text('Une autre idée'), findsOneWidget);
    });

    testWidgets('explique quand rien ne correspond', (tester) async {
      await pumpSection(tester);

      await tester.tap(find.text('Action'));
      await tester.tap(find.text('30 min'));
      await tester.pump();
      await tester.tap(find.text('Surprends-moi'));
      await tester.pumpAndSettle();

      expect(find.text('Rien ne correspond dans votre liste.'), findsOneWidget);
    });
  });

  group('genres', () {
    test('le DTO lit les genres inclus', () {
      final details = AnimeDetailsDto.fromJson({
        'data': [
          {
            'id': '5',
            'attributes': {'subtype': 'TV', 'episodeLength': 24},
            'relationships': {
              'categories': {
                'data': [
                  {'type': 'categories', 'id': '10'},
                  {'type': 'categories', 'id': '99'},
                ],
              },
            },
          },
        ],
        'included': [
          {
            'type': 'categories',
            'id': '10',
            'attributes': {'title': 'Action', 'slug': 'action'},
          },
          {'type': 'people', 'id': '1', 'attributes': <String, dynamic>{}},
        ],
      });

      expect(details[5]?.genres.single.slug, 'action');
      expect(details[5]?.episodeMinutes, 24);
      expect(details[5]?.hasGenre('action'), isTrue);
      expect(details[5]?.hasGenre('drama'), isFalse);
    });

    test('les libellés sont traduits avec repli sur le titre', () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('fr'));

      expect(genreLabel(l10n, genre('comedy')), 'Comédie');
      expect(genreLabel(l10n, genre('slice-of-life')), 'Tranche de vie');
      expect(genreLabel(l10n, genre('unknown', 'Étrange')), 'Étrange');

      for (final slug in [
        'action', 'adventure', 'drama', 'fantasy', 'horror', 'mystery',
        'romance', 'science-fiction', 'sports', 'supernatural', 'thriller',
        'psychological', 'mecha',
      ]) {
        expect(genreLabel(l10n, genre(slug)), isNot(slug));
      }
    });
  });
}
