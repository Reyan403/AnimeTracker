import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:monapp/layers/functional/Anime/data/gateways/local_watchlist_gateway.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Anime/domain/use_cases/find_watch_status_use_case.dart';
import 'package:monapp/layers/functional/Catalogue/data/gateways/mymemory_synopsis_translation_gateway.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/anime_sheet_cubit.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/anime_sheet_state.dart';
import 'package:monapp/layers/functional/Settings/domain/gateways/settings_gateway.dart';
import 'package:monapp/layers/functional/Settings/domain/use_cases/read_spoiler_guard_use_case.dart';
import 'package:monapp/layers/functional/Catalogue/data/models/anime_sheet_cache_dto.dart';
import 'package:monapp/layers/functional/Catalogue/data/models/translation_dto.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/anime_sheet.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/anime_sheet_gateway.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/french_synopsis_gateway.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/synopsis_translation_gateway.dart';
import 'package:monapp/layers/functional/Catalogue/domain/use_cases/load_anime_sheet_use_case.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/widgets/anime_sheet_body.dart';
import 'package:monapp/layers/technical/MyMemoryApi/mymemory_client.dart';

import '../../support/fake_caches.dart';
import '../../support/fake_watchlist_store.dart';
import '../../support/pump_app.dart';

const english = AnimeSheet(
  id: 1,
  title: 'Monster',
  format: 'Série TV',
  synopsis: 'A surgeon hunts a killer.',
);

class StaticSheetGateway implements AnimeSheetGateway {
  const StaticSheetGateway(this.sheet);

  final AnimeSheet sheet;

  @override
  Future<AnimeSheet> findById(int id) async => sheet;
}

class StaticFrenchGateway implements FrenchSynopsisGateway {
  const StaticFrenchGateway([this.synopsis]);

  final String? synopsis;

  @override
  Future<String?> findFor(String title) async => synopsis;
}

class GatedTranslationGateway implements SynopsisTranslationGateway {
  GatedTranslationGateway(this.gate);

  final Completer<void> gate;
  final List<String> received = [];

  @override
  Future<String?> translateToFrench(String text) async {
    await gate.future;
    received.add(text);

    return 'Traduit.';
  }
}

class AlwaysGuardSettings implements SettingsGateway {
  @override
  bool get isSpoilerGuardEnabled => true;

  @override
  void changeSpoilerGuard({required bool enabled}) {}
}

class StaticTranslationGateway implements SynopsisTranslationGateway {
  StaticTranslationGateway({this.result, this.throws = false});

  final String? result;
  final bool throws;
  final List<String> received = [];

  @override
  Future<String?> translateToFrench(String text) async {
    received.add(text);

    if (throws) {
      throw const MyMemoryRequestFailedException(500);
    }

    return result;
  }
}

LoadAnimeSheetUseCase useCaseOf({
  AnimeSheet sheet = english,
  String? french,
  required SynopsisTranslationGateway translation,
  FakeSheetCache? cache,
}) => LoadAnimeSheetUseCase(
  StaticSheetGateway(sheet),
  StaticFrenchGateway(french),
  translation,
  cache ?? FakeSheetCache(),
);

String reply(String text, {int status = 200, bool quota = false}) =>
    jsonEncode({
      'responseData': {'translatedText': text},
      'responseStatus': status,
      'quotaFinished': quota,
    });

Future<AnimeSheet> lastOf(Stream<AnimeSheet> sheets) async =>
    (await sheets.toList()).last;

void main() {
  group('TranslationDto', () {
    test('garde un texte court en un seul morceau', () {
      expect(TranslationDto.chunksOf('Bonjour. Salut.'), ['Bonjour. Salut.']);
    });

    test('découpe un long texte aux fins de phrases', () {
      final sentence = '${'mot ' * 30}fin.';
      final chunks = TranslationDto.chunksOf(
        List.filled(8, sentence).join(' '),
      );

      expect(chunks.length, greaterThan(1));
      expect(chunks.every((chunk) => chunk.length <= 450), isTrue);
      expect(chunks.join(' '), List.filled(8, sentence).join(' '));
    });

    test('coupe une phrase interminable', () {
      final chunks = TranslationDto.chunksOf('a' * 1000);

      expect(chunks.map((chunk) => chunk.length), [450, 450, 100]);
    });

    test('un texte vide ne donne aucun morceau', () {
      expect(TranslationDto.chunksOf('   '), isEmpty);
    });

    test('lit la traduction et décode les entités', () {
      expect(
        TranslationDto.textFrom(
          jsonDecode(reply('L&#39;ami &amp; l&quot;ennemi'))
              as Map<String, dynamic>,
        ),
        'L\'ami & l"ennemi',
      );
    });

    test('refuse un quota épuisé ou une réponse invalide', () {
      expect(
        TranslationDto.textFrom(
          jsonDecode(reply('x', quota: true)) as Map<String, dynamic>,
        ),
        isNull,
      );
      expect(
        TranslationDto.textFrom(
          jsonDecode(reply('x', status: 429)) as Map<String, dynamic>,
        ),
        isNull,
      );
      expect(
        TranslationDto.textFrom(
          jsonDecode(reply('MYMEMORY WARNING: YOU USED ALL'))
              as Map<String, dynamic>,
        ),
        isNull,
      );
      expect(
        TranslationDto.textFrom(jsonDecode(reply('')) as Map<String, dynamic>),
        isNull,
      );
      expect(TranslationDto.textFrom(const {}), isNull);
    });
  });

  group('MyMemorySynopsisTranslationGateway', () {
    MyMemorySynopsisTranslationGateway gatewayReplying(
      http.Response Function(http.Request request) answer, {
      List<Uri>? seen,
    }) => MyMemorySynopsisTranslationGateway(
      MyMemoryClient(
        MockClient((request) async {
          seen?.add(request.url);

          return answer(request);
        }),
      ),
    );

    test('traduit chaque paragraphe de l anglais vers le français', () async {
      final seen = <Uri>[];
      final gateway = gatewayReplying(
        (request) => http.Response(
          reply('FR(${request.url.queryParameters['q']})'),
          200,
        ),
        seen: seen,
      );

      final result = await gateway.translateToFrench('One.\n\nTwo.');

      expect(result, 'FR(One.)\n\nFR(Two.)');
      expect(seen.first.queryParameters['langpair'], 'en|fr');
    });

    test('abandonne si le quota est épuisé', () async {
      final gateway = gatewayReplying(
        (_) => http.Response(reply('x', quota: true), 200),
      );

      expect(await gateway.translateToFrench('Hello.'), isNull);
    });

    test('abandonne sur une erreur réseau', () async {
      final gateway = gatewayReplying((_) => http.Response('', 500));

      expect(await gateway.translateToFrench('Hello.'), isNull);
      expect(
        const MyMemoryRequestFailedException(500).toString(),
        contains('500'),
      );
    });

    test('un texte vide n appelle pas le service', () async {
      final seen = <Uri>[];
      final gateway = gatewayReplying(
        (_) => http.Response(reply('x'), 200),
        seen: seen,
      );

      expect(await gateway.translateToFrench('  \n '), isNull);
      expect(seen, isEmpty);
    });
  });

  group('LoadAnimeSheetUseCase et traduction', () {
    test('garde le synopsis français de TMDB sans traduire', () async {
      final translation = StaticTranslationGateway(result: 'ignoré');

      final sheet = await lastOf(
        useCaseOf(french: 'Résumé TMDB', translation: translation)(1),
      );

      expect(sheet.synopsis, 'Résumé TMDB');
      expect(sheet.isSynopsisTranslated, isFalse);
      expect(translation.received, isEmpty);
    });

    test('traduit le synopsis anglais quand TMDB n a rien', () async {
      final cache = FakeSheetCache();
      final translation = StaticTranslationGateway(result: 'Un chirurgien.');

      final sheet = await lastOf(
        useCaseOf(translation: translation, cache: cache)(1),
      );

      expect(sheet.synopsis, 'Un chirurgien.');
      expect(sheet.isSynopsisTranslated, isTrue);
      expect(translation.received.single, 'A surgeon hunts a killer.');
      expect(cache.stored[1]?.isSynopsisTranslated, isTrue);
    });

    test('garde l anglais si la traduction échoue', () async {
      final sheet = await lastOf(
        useCaseOf(translation: StaticTranslationGateway())(1),
      );

      expect(sheet.synopsis, 'A surgeon hunts a killer.');
      expect(sheet.isSynopsisTranslated, isFalse);
    });

    test('garde l anglais si la traduction lève une erreur', () async {
      final sheet = await lastOf(
        useCaseOf(translation: StaticTranslationGateway(throws: true))(1),
      );

      expect(sheet.synopsis, 'A surgeon hunts a killer.');
    });

    test('ne traduit rien sans synopsis', () async {
      final translation = StaticTranslationGateway(result: 'x');

      final sheet = await lastOf(
        useCaseOf(
          sheet: const AnimeSheet(id: 1, title: 'M', format: 'TV'),
          translation: translation,
        )(1),
      );

      expect(sheet.synopsis, isNull);
      expect(translation.received, isEmpty);
    });
  });

  group('chargement progressif de la fiche', () {
    test('la fiche arrive avant la fin de la traduction', () async {
      final gate = Completer<void>();
      final translation = GatedTranslationGateway(gate);
      final stream = StreamIterator(useCaseOf(translation: translation)(1));

      expect(await stream.moveNext(), isTrue);
      expect(stream.current.synopsis, 'A surgeon hunts a killer.');
      expect(stream.current.isSynopsisTranslated, isFalse);
      expect(translation.received, isEmpty);

      final next = stream.moveNext();
      gate.complete();

      expect(await next, isTrue);
      expect(stream.current.synopsis, 'Traduit.');
      expect(stream.current.isSynopsisTranslated, isTrue);
      expect(await stream.moveNext(), isFalse);
    });

    test('une traduction déjà enregistrée est réutilisée sans appel', () async {
      final cache = FakeSheetCache({
        1: english.withTranslatedSynopsis('Déjà traduit.'),
      });
      final translation = StaticTranslationGateway(result: 'Nouveau');

      final sheets = await useCaseOf(translation: translation, cache: cache)(1)
          .toList();

      expect(sheets.length, 1);
      expect(sheets.single.synopsis, 'Déjà traduit.');
      expect(sheets.single.isSynopsisTranslated, isTrue);
      expect(translation.received, isEmpty);
    });

    test('émet une seule fois quand rien ne change', () async {
      final sheets = await useCaseOf(translation: StaticTranslationGateway())(1)
          .toList();

      expect(sheets.length, 1);
    });
  });

  group('MyMemorySynopsisTranslationGateway en parallèle', () {
    test('lance toutes les requêtes avant d attendre la première', () async {
      var running = 0;
      var peak = 0;
      final gateway = MyMemorySynopsisTranslationGateway(
        MyMemoryClient(
          MockClient((request) async {
            running++;
            peak = peak > running ? peak : running;
            await Future<void>.delayed(const Duration(milliseconds: 20));
            running--;

            return http.Response(reply('FR'), 200);
          }),
        ),
      );
      final text = List.filled(6, '${'mot ' * 100}fin.').join('\n');

      await gateway.translateToFrench(text);

      expect(peak, greaterThan(1));
    });
  });

  group('AnimeSheetCubit progressif', () {
    AnimeSheetCubit cubitWith(Completer<void> gate) {
      final cubit = AnimeSheetCubit(
        LoadAnimeSheetUseCase(
          const StaticSheetGateway(english),
          const StaticFrenchGateway(),
          GatedTranslationGateway(gate),
          FakeSheetCache(),
        ),
        FindWatchStatusUseCase(
          LocalWatchlistGateway(
            FakeWatchlistStore([
              const WatchlistEntry(
                id: 1,
                title: 'Monster',
                status: WatchStatus.watching,
              ),
            ]),
            const [],
          ),
        ),
        ReadSpoilerGuardUseCase(AlwaysGuardSettings()),
      );
      addTearDown(cubit.close);

      return cubit;
    }

    test('affiche la fiche avant la traduction puis la met à jour', () async {
      final gate = Completer<void>();
      final cubit = cubitWith(gate);
      final loading = cubit.load(1);

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(cubit.state.status, AnimeSheetStatus.success);
      expect(cubit.state.sheet?.synopsis, 'A surgeon hunts a killer.');
      expect(cubit.state.isSynopsisHidden, isTrue);

      gate.complete();
      await loading;

      expect(cubit.state.sheet?.synopsis, 'Traduit.');
      expect(cubit.state.sheet?.isSynopsisTranslated, isTrue);
    });

    test('un synopsis révélé le reste quand la traduction arrive', () async {
      final gate = Completer<void>();
      final cubit = cubitWith(gate);
      final loading = cubit.load(1);

      await Future<void>.delayed(const Duration(milliseconds: 20));
      cubit.revealSynopsis();
      gate.complete();
      await loading;

      expect(cubit.state.sheet?.synopsis, 'Traduit.');
      expect(cubit.state.isSynopsisHidden, isFalse);
    });
  });

  group('fiche', () {
    test('le drapeau de traduction survit au cache', () {
      final restored = AnimeSheetCacheDto.fromJson(
        AnimeSheetCacheDto.toJson(english.withTranslatedSynopsis('Bonjour')),
      );

      expect(restored.synopsis, 'Bonjour');
      expect(restored.isSynopsisTranslated, isTrue);
    });

    test('un ancien cache sans drapeau reste non traduit', () {
      final json = AnimeSheetCacheDto.toJson(english)
        ..remove('isSynopsisTranslated');

      expect(AnimeSheetCacheDto.fromJson(json).isSynopsisTranslated, isFalse);
    });

    testWidgets('affiche la mention de traduction automatique', (tester) async {
      await pumpApp(
        tester,
        AnimeSheetBody(
          sheet: english.withTranslatedSynopsis('Un chirurgien.'),
          heroTag: 'poster-test-1',
        ),
        size: const Size(500, 1400),
      );

      expect(find.text('Un chirurgien.'), findsOneWidget);
      expect(
        find.text('Traduit automatiquement de l\'anglais.'),
        findsOneWidget,
      );
    });

    testWidgets('pas de mention pour un synopsis d origine', (tester) async {
      await pumpApp(
        tester,
        const AnimeSheetBody(sheet: english, heroTag: 'poster-test-1'),
        size: const Size(500, 1400),
      );

      expect(find.text('Traduit automatiquement de l\'anglais.'), findsNothing);
    });

    testWidgets('pas de mention tant que le synopsis est flouté', (
      tester,
    ) async {
      await pumpApp(
        tester,
        AnimeSheetBody(
          sheet: english.withTranslatedSynopsis('Un chirurgien.'),
          heroTag: 'poster-test-1',
          isSynopsisHidden: true,
        ),
        size: const Size(500, 1400),
      );

      expect(find.text('Traduit automatiquement de l\'anglais.'), findsNothing);
    });
  });
}
