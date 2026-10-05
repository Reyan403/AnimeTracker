import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:monapp/layers/functional/Animedex/data/gateways/ani_list_booster_candidate_gateway.dart';
import 'package:monapp/layers/functional/Animedex/data/rules/rarity_rule.dart';
import 'package:monapp/layers/functional/Animedex/domain/gateways/booster_candidate_gateway.dart';

import 'domain_data_anilist_support.dart';

final DateTime moment = DateTime(2026, 10, 5, 10);

final RegExp pageNumber = RegExp(r'Page\(page: (\d+), perPage: 1\)');

List<int> pagesOf(String query) => [
  for (final match in pageNumber.allMatches(query)) int.parse(match.group(1)!),
];

Future<http.Response> replyWith(
  http.Request request,
  Map<String, dynamic> Function(String query) build,
) async {
  final body = jsonDecode(request.body) as Map<String, dynamic>;

  return jsonResponse(build(body['query'] as String));
}

Map<String, dynamic> pagesFor(String query) => characterResponse([
  for (final page in pagesOf(query)) characterPage(id: page),
]);

void main() {
  group('AniListBoosterCandidateGateway', () {
    test('envoie une seule requête avec un alias par carte', () async {
      final queries = <String>[];
      final gateway = AniListBoosterCandidateGateway(
        clientReplying((request) {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          queries.add(body['query'] as String);

          return replyWith(request, pagesFor);
        }),
        random: Random(3),
      );

      final cards = await gateway.drawCandidates(5, obtainedOn: moment);

      expect(queries, hasLength(1));
      expect(queries.single, contains('c0: Page('));
      expect(queries.single, contains('characters(sort: FAVOURITES_DESC)'));
      expect(queries.single, contains('sort: POPULARITY_DESC'));
      expect(pagesOf(queries.single).toSet(), hasLength(5));
      expect(cards, hasLength(5));
      expect(cards.every((card) => card.obtainedOn == moment), isTrue);
    });

    test('tire les pages dans les tranches de rang valides', () async {
      final pages = <int>[];
      final gateway = AniListBoosterCandidateGateway(
        clientReplying((request) {
          return replyWith(request, (query) {
            pages.addAll(pagesOf(query));

            return pagesFor(query);
          });
        }),
        random: Random(11),
      );

      for (var draw = 0; draw < 40; draw++) {
        await gateway.drawCandidates(5, obtainedOn: moment);
      }

      expect(pages.every((page) => page >= 1 && page <= 5000), isTrue);
      expect(
        pages.any((page) => page < RarityRule.bands.values.first.end),
        isTrue,
      );
    });

    test('exclut les identifiants déjà connus et les doublons', () async {
      final gateway = AniListBoosterCandidateGateway(
        clientReplying(
          (request) async => jsonResponse(
            characterResponse([
              characterPage(id: 1),
              characterPage(id: 2),
              characterPage(id: 2),
              characterPage(id: 3),
            ]),
          ),
        ),
      );

      final cards = await gateway.drawCandidates(
        4,
        obtainedOn: moment,
        excludedIds: {1},
      );

      expect(cards.map((card) => card.characterId), [2, 3]);
    });

    test('renvoie moins de cartes quand certains alias sont vides', () async {
      final gateway = AniListBoosterCandidateGateway(
        clientReplying(
          (request) async => jsonResponse({
            'data': {
              'c0': characterPage(id: 4),
              'c1': {'characters': <Object>[]},
              'c2': null,
            },
          }),
        ),
      );

      final cards = await gateway.drawCandidates(3, obtainedOn: moment);

      expect(cards.single.characterId, 4);
    });

    test('lève BoosterUnavailableException sur une erreur HTTP', () async {
      final gateway = AniListBoosterCandidateGateway(
        clientReplying((request) async => http.Response('{}', 429)),
      );

      expect(
        gateway.drawCandidates(5, obtainedOn: moment),
        throwsA(isA<BoosterUnavailableException>()),
      );
    });

    test('lève BoosterUnavailableException sur une réponse vide', () async {
      final gateway = AniListBoosterCandidateGateway(
        clientReplying((request) async => jsonResponse({'data': null})),
      );

      expect(
        gateway.drawCandidates(5, obtainedOn: moment),
        throwsA(isA<BoosterUnavailableException>()),
      );
    });

    test('lève BoosterUnavailableException si tout est exclu', () async {
      final gateway = AniListBoosterCandidateGateway(
        clientReplying(
          (request) async =>
              jsonResponse(characterResponse([characterPage(id: 1)])),
        ),
      );

      expect(
        gateway.drawCandidates(1, obtainedOn: moment, excludedIds: {1}),
        throwsA(isA<BoosterUnavailableException>()),
      );
    });

    test('abandonne après le délai court', () async {
      final gateway = AniListBoosterCandidateGateway(
        clientReplying((request) {
          return Completer<http.Response>().future;
        }),
        requestTimeout: const Duration(milliseconds: 20),
      );

      await expectLater(
        gateway.drawCandidates(5, obtainedOn: moment),
        throwsA(isA<BoosterUnavailableException>()),
      );
    });

    test('buildQuery produit un alias par page demandée', () {
      final query = AniListBoosterCandidateGateway.buildQuery([5, 40]);

      expect(query, contains('c0: Page(page: 5, perPage: 1)'));
      expect(query, contains('c1: Page(page: 40, perPage: 1)'));
      expect(query, isNot(contains('c2:')));
    });
  });
}
