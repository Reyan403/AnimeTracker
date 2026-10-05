import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:monapp/layers/functional/Catalogue/data/gateways/kitsu_anime_extras_gateway.dart';
import 'package:monapp/layers/functional/Catalogue/data/models/anime_extras_dto.dart';
import 'package:monapp/layers/functional/Catalogue/data/models/anime_sheet_cache_dto.dart';
import 'package:monapp/layers/functional/Catalogue/data/models/anime_sheet_dto.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/anime_extras.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/anime_sheet.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/catalogue_anime.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/anime_extras_gateway.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/link_opener_gateway.dart';
import 'package:monapp/layers/functional/Catalogue/domain/use_cases/load_anime_extras_use_case.dart';
import 'package:monapp/layers/functional/Catalogue/domain/use_cases/open_external_link_use_case.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/anime_extras_cubit.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/widgets/anime_extras_section.dart';
import 'package:monapp/layers/technical/Injection/injection.dart';
import 'package:monapp/layers/technical/KitsuApi/kitsu_client.dart';

import '../../support/pump_app.dart';

CatalogueAnime animeOf(int id, String title) => CatalogueAnime(
  id: id,
  title: title,
  format: 'Série TV',
  year: 2013,
  episodeCount: 25,
);

const netflix = StreamingLink(siteName: 'Netflix', url: 'https://netflix/70');
const hulu = StreamingLink(siteName: 'Hulu', url: 'https://hulu/aot');

class FakeExtrasGateway implements AnimeExtrasGateway {
  FakeExtrasGateway({
    this.links = const [],
    this.related = const [],
    this.linksFail = false,
    this.relatedFail = false,
    this.gate,
  });

  final List<StreamingLink> links;
  final List<RelatedAnime> related;
  final bool linksFail;
  final bool relatedFail;
  final Completer<void>? gate;
  int calls = 0;

  @override
  Future<List<StreamingLink>> findStreamingLinks(int animeId) async {
    calls++;
    await gate?.future;

    if (linksFail) {
      throw const AnimeExtrasUnavailableException();
    }

    return links;
  }

  @override
  Future<List<RelatedAnime>> findRelated(int animeId) async {
    await gate?.future;

    if (relatedFail) {
      throw const AnimeExtrasUnavailableException();
    }

    return related;
  }
}

class FakeLinkOpener implements LinkOpenerGateway {
  FakeLinkOpener({this.succeeds = true});

  final bool succeeds;
  final List<Uri> opened = [];

  @override
  Future<bool> open(Uri uri) async {
    opened.add(uri);

    return succeeds;
  }
}

final sequel = RelatedAnime(
  anime: animeOf(2, 'Suite de Monster'),
  role: RelationRole.sequel,
);
final prequel = RelatedAnime(
  anime: animeOf(3, 'Avant Monster'),
  role: RelationRole.prequel,
);

void main() {
  group('AnimeExtrasDto', () {
    test('lit les plateformes et ignore les doublons et liens incomplets', () {
      final links = AnimeExtrasDto.streamingLinksFrom({
        'data': [
          {
            'attributes': {'url': 'https://netflix/1'},
            'relationships': {
              'streamer': {
                'data': {'id': '6'},
              },
            },
          },
          {
            'attributes': {'url': 'https://netflix/2'},
            'relationships': {
              'streamer': {
                'data': {'id': '6'},
              },
            },
          },
          {
            'attributes': {'url': 'https://sans-site'},
            'relationships': {
              'streamer': {
                'data': {'id': '99'},
              },
            },
          },
          {
            'attributes': <String, dynamic>{},
            'relationships': {
              'streamer': {
                'data': {'id': '6'},
              },
            },
          },
        ],
        'included': [
          {
            'type': 'streamers',
            'id': '6',
            'attributes': {'siteName': 'Netflix'},
          },
        ],
      });

      expect(links.single.siteName, 'Netflix');
      expect(links.single.url, 'https://netflix/1');
    });

    test('lit les suites et préquelles, préquelles d abord', () {
      final related = AnimeExtrasDto.relatedFrom({
        'data': [
          {
            'attributes': {'role': 'sequel'},
            'relationships': {
              'destination': {
                'data': {'type': 'anime', 'id': '2'},
              },
            },
          },
          {
            'attributes': {'role': 'other'},
            'relationships': {
              'destination': {
                'data': {'type': 'anime', 'id': '4'},
              },
            },
          },
          {
            'attributes': {'role': 'prequel'},
            'relationships': {
              'destination': {
                'data': {'type': 'anime', 'id': '3'},
              },
            },
          },
          {
            'attributes': {'role': 'sequel'},
            'relationships': {
              'destination': {
                'data': {'type': 'manga', 'id': '9'},
              },
            },
          },
        ],
        'included': [
          {
            'type': 'anime',
            'id': '2',
            'attributes': {'canonicalTitle': 'Suite', 'subtype': 'TV'},
          },
          {
            'type': 'anime',
            'id': '3',
            'attributes': {'canonicalTitle': 'Avant', 'subtype': 'TV'},
          },
          {
            'type': 'anime',
            'id': '4',
            'attributes': {'canonicalTitle': 'Autre', 'subtype': 'TV'},
          },
        ],
      });

      expect(related.map((item) => item.anime.id), [3, 2]);
      expect(related.first.role, RelationRole.prequel);
    });

    test('tolère des réponses vides', () {
      expect(AnimeExtrasDto.streamingLinksFrom(const {}), isEmpty);
      expect(AnimeExtrasDto.relatedFrom(const {}), isEmpty);
    });
  });

  group('KitsuAnimeExtrasGateway', () {
    KitsuAnimeExtrasGateway gatewayReplying(
      http.Response Function(http.Request request) reply, {
      List<Uri>? seen,
    }) => KitsuAnimeExtrasGateway(
      KitsuClient(
        MockClient((request) async {
          seen?.add(request.url);

          return reply(request);
        }),
      ),
    );

    test('demande peu de champs pour rester léger', () async {
      final seen = <Uri>[];
      final gateway = gatewayReplying(
        (_) => http.Response(jsonEncode({'data': []}), 200),
        seen: seen,
      );

      await gateway.findStreamingLinks(7);
      await gateway.findRelated(7);

      expect(seen.first.path, contains('anime/7/streaming-links'));
      expect(seen.first.query, contains('fields%5Bstreamers%5D=siteName'));
      expect(seen.last.path, contains('anime/7/media-relationships'));
      expect(seen.last.query, contains('page%5Blimit%5D=20'));
    });

    test('traduit un échec en indisponibilité', () {
      final gateway = gatewayReplying((_) => http.Response('', 500));

      expect(
        gateway.findStreamingLinks(7),
        throwsA(isA<AnimeExtrasUnavailableException>()),
      );
      expect(
        gateway.findRelated(7),
        throwsA(isA<AnimeExtrasUnavailableException>()),
      );
      expect(
        const AnimeExtrasUnavailableException().toString(),
        contains('unavailable'),
      );
    });
  });

  group('LoadAnimeExtrasUseCase', () {
    test('réunit plateformes et suites', () async {
      final extras = await LoadAnimeExtrasUseCase(
        FakeExtrasGateway(links: [netflix], related: [prequel, sequel]),
      )(1);

      expect(extras.streamingLinks, [netflix]);
      expect(extras.related.length, 2);
      expect(extras.isEmpty, isFalse);
    });

    test('mémorise le résultat pour ne pas rappeler le service', () async {
      final gateway = FakeExtrasGateway(links: [netflix]);
      final useCase = LoadAnimeExtrasUseCase(gateway);

      await useCase(1);
      await useCase(1);

      expect(gateway.calls, 1);
    });

    test('retente quand le résultat était vide', () async {
      final gateway = FakeExtrasGateway();
      final useCase = LoadAnimeExtrasUseCase(gateway);

      await useCase(1);
      await useCase(1);

      expect(gateway.calls, 2);
    });

    test('garde l autre source quand une des deux échoue', () async {
      final extras = await LoadAnimeExtrasUseCase(
        FakeExtrasGateway(linksFail: true, related: [sequel]),
      )(1);

      expect(extras.streamingLinks, isEmpty);
      expect(extras.related.single.role, RelationRole.sequel);
    });

    test('renvoie vide quand tout échoue', () async {
      final extras = await LoadAnimeExtrasUseCase(
        FakeExtrasGateway(linksFail: true, relatedFail: true),
      )(1);

      expect(extras.isEmpty, isTrue);
    });
  });

  group('OpenExternalLinkUseCase', () {
    test('ouvre un lien et construit l adresse de la bande-annonce', () async {
      final opener = FakeLinkOpener();
      final useCase = OpenExternalLinkUseCase(opener);

      expect(await useCase('https://example.invalid/x'), isTrue);
      expect(await useCase.openTrailer('abc123'), isTrue);

      expect(opener.opened.first.toString(), 'https://example.invalid/x');
      expect(
        opener.opened.last.toString(),
        'https://www.youtube.com/watch?v=abc123',
      );
    });
  });

  group('AnimeExtrasCubit', () {
    AnimeExtrasCubit cubitOf(FakeExtrasGateway gateway, FakeLinkOpener opener) {
      final cubit = AnimeExtrasCubit(
        LoadAnimeExtrasUseCase(gateway),
        OpenExternalLinkUseCase(opener),
      );
      addTearDown(cubit.close);

      return cubit;
    }

    test('charge puis passe à prêt', () async {
      final cubit = cubitOf(
        FakeExtrasGateway(links: [netflix]),
        FakeLinkOpener(),
      );

      expect(cubit.state.status, AnimeExtrasStatus.loading);

      await cubit.load(1);

      expect(cubit.state.status, AnimeExtrasStatus.ready);
      expect(cubit.state.extras.streamingLinks, [netflix]);
    });

    test('ouvre la bande-annonce et les plateformes', () async {
      final opener = FakeLinkOpener();
      final cubit = cubitOf(FakeExtrasGateway(), opener);

      await cubit.openTrailer('abc');
      await cubit.openStreaming(netflix);

      expect(opener.opened.length, 2);
      expect(cubit.state.linkFailed, isFalse);
    });

    test('signale un lien impossible à ouvrir', () async {
      final cubit = cubitOf(
        FakeExtrasGateway(),
        FakeLinkOpener(succeeds: false),
      );

      await cubit.openTrailer('abc');

      expect(cubit.state.linkFailed, isTrue);
    });
  });

  group('fiche et bande-annonce', () {
    test('le DTO lit l identifiant YouTube', () {
      final sheet = AnimeSheetDto.fromJson({
        'data': {
          'id': '1',
          'attributes': {
            'canonicalTitle': 'Monster',
            'subtype': 'TV',
            'youtubeVideoId': 'LHtdKWJdif4',
          },
        },
      });

      expect(sheet.trailerId, 'LHtdKWJdif4');
    });

    test('une absence de bande-annonce reste nulle', () {
      final sheet = AnimeSheetDto.fromJson({
        'data': {
          'id': '1',
          'attributes': {'canonicalTitle': 'Monster', 'subtype': 'TV'},
        },
      });

      expect(sheet.trailerId, isNull);
    });

    test('l identifiant survit au cache et aux copies', () {
      const sheet = AnimeSheet(
        id: 1,
        title: 'Monster',
        format: 'TV',
        trailerId: 'abc',
      );
      final restored = AnimeSheetCacheDto.fromJson(
        AnimeSheetCacheDto.toJson(sheet.withSynopsis('Résumé')),
      );

      expect(restored.trailerId, 'abc');
    });
  });

  group('AnimeExtrasSection', () {
    late FakeLinkOpener opener;

    Future<void> pumpSection(
      WidgetTester tester,
      FakeExtrasGateway gateway, {
      String? trailerId = 'abc',
      void Function(int, String)? onRelated,
      bool settle = true,
      bool linkSucceeds = true,
    }) async {
      opener = FakeLinkOpener(succeeds: linkSucceeds);
      await getIt.reset();
      getIt.registerFactory<AnimeExtrasCubit>(
        () => AnimeExtrasCubit(
          LoadAnimeExtrasUseCase(gateway),
          OpenExternalLinkUseCase(opener),
        ),
      );

      await pumpApp(
        tester,
        SingleChildScrollView(
          child: AnimeExtrasSection(
            animeId: 1,
            trailerId: trailerId,
            onRelatedSelected: onRelated ?? (_, _) {},
          ),
        ),
        size: const Size(500, 1200),
        settle: settle,
      );
    }

    tearDown(() async => getIt.reset());

    testWidgets('affiche bande-annonce, plateformes et suites', (tester) async {
      int? opened;

      await pumpSection(
        tester,
        FakeExtrasGateway(links: [netflix, hulu], related: [prequel, sequel]),
        onRelated: (id, _) => opened = id,
      );

      expect(find.text('Où regarder'), findsOneWidget);
      expect(find.text('Bande-annonce'), findsOneWidget);
      expect(find.text('Netflix'), findsOneWidget);
      expect(find.text('Hulu'), findsOneWidget);
      expect(find.text('Suites et préquelles'), findsOneWidget);
      expect(find.text('Préquelle'), findsOneWidget);
      expect(find.text('Suite'), findsOneWidget);

      await tester.tap(find.text('Suite de Monster'));

      expect(opened, 2);
    });

    testWidgets('ouvre la bande-annonce et une plateforme', (tester) async {
      await pumpSection(tester, FakeExtrasGateway(links: [netflix]));

      await tester.tap(find.text('Bande-annonce'));
      await tester.tap(find.text('Netflix'));

      expect(opener.opened.map((uri) => uri.toString()), [
        'https://www.youtube.com/watch?v=abc',
        'https://netflix/70',
      ]);
    });

    testWidgets(
      'le bouton de bande-annonce est là avant la fin du chargement',
      (tester) async {
        final gate = Completer<void>();

        await pumpSection(
          tester,
          FakeExtrasGateway(links: [netflix], gate: gate),
          settle: false,
        );

        expect(find.text('Bande-annonce'), findsOneWidget);
        expect(find.text('Netflix'), findsNothing);

        gate.complete();
        await tester.pumpAndSettle();

        expect(find.text('Netflix'), findsOneWidget);
      },
    );

    testWidgets('masque Où regarder sans bande-annonce ni plateforme', (
      tester,
    ) async {
      await pumpSection(
        tester,
        FakeExtrasGateway(related: [sequel]),
        trailerId: null,
      );

      expect(find.text('Où regarder'), findsNothing);
      expect(find.text('Suites et préquelles'), findsOneWidget);
    });

    testWidgets('prévient quand un lien ne s ouvre pas', (tester) async {
      await pumpSection(tester, FakeExtrasGateway(), linkSucceeds: false);

      await tester.tap(find.text('Bande-annonce'));
      await tester.pumpAndSettle();

      expect(find.text('Impossible d\x27ouvrir ce lien.'), findsOneWidget);
    });
  });
}
