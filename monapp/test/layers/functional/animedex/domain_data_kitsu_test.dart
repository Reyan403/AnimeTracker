import 'dart:async';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:monapp/layers/functional/Animedex/data/gateways/kitsu_booster_candidate_gateway.dart';
import 'package:monapp/layers/functional/Animedex/data/rules/rarity_rule.dart';
import 'package:monapp/layers/functional/Animedex/domain/gateways/booster_candidate_gateway.dart';

import '../../../support/animedex_fakes.dart';

final DateTime moment = DateTime(2026, 10, 5, 10);

void main() {
  group('KitsuBoosterCandidateGateway', () {
    test('interroge Kitsu en parallèle avec les bons filtres', () async {
      final requests = <Uri>[];
      var inFlight = 0;
      var maxInFlight = 0;
      var nextId = 1;
      final gateway = KitsuBoosterCandidateGateway(
        clientReplying((request) async {
          requests.add(request.url);
          inFlight++;
          maxInFlight = max(maxInFlight, inFlight);
          await Future<void>.delayed(const Duration(milliseconds: 20));
          inFlight--;

          return jsonResponse(payload(id: nextId++));
        }),
        random: Random(3),
      );

      final cards = await gateway.drawCandidates(5, obtainedOn: moment);

      expect(requests.length, greaterThanOrEqualTo(3));
      expect(maxInFlight, requests.length);
      expect(cards.length, requests.length);

      final query = requests.first.query;
      expect(query, contains('filter%5BuserCount%5D=2000..'));
      expect(query, contains('filter%5Bsubtype%5D=TV,movie'));
      expect(query, contains('sort=ratingRank'));
      expect(query, contains('include=categories'));
      expect(query, contains('page%5Blimit%5D=1'));
    });

    test('utilise des décalages distincts et bornés', () async {
      final offsets = <int>[];
      final gateway = KitsuBoosterCandidateGateway(
        clientReplying((request) async {
          offsets.add(int.parse(request.url.queryParameters['page[offset]']!));

          return jsonResponse(payload(id: offsets.length));
        }),
        random: Random(11),
      );

      await gateway.drawCandidates(5, obtainedOn: moment);

      expect(offsets.toSet().length, offsets.length);
      expect(offsets.every((offset) => offset >= 0 && offset < 3300), isTrue);
    });

    test('écarte les identifiants exclus et les doublons', () async {
      final gateway = KitsuBoosterCandidateGateway(
        clientReplying((_) async => jsonResponse(payload(id: 4))),
        random: Random(5),
      );

      final cards = await gateway.drawCandidates(5, obtainedOn: moment);

      expect(cards.map((card) => card.animeId), [4]);
      expect(
        gateway.drawCandidates(5, obtainedOn: moment, excludedIds: {4}),
        throwsA(isA<BoosterUnavailableException>()),
      );
    });

    test('garde les cartes obtenues malgré un échec partiel', () async {
      var calls = 0;
      final gateway = KitsuBoosterCandidateGateway(
        clientReplying((_) async {
          calls++;

          return calls.isEven
              ? http.Response('', 500)
              : jsonResponse(payload(id: calls));
        }),
        random: Random(9),
      );

      final cards = await gateway.drawCandidates(5, obtainedOn: moment);

      expect(cards, isNotEmpty);
      expect(cards.length, lessThan(calls));
    });

    test('signale l indisponibilité quand tout échoue', () {
      final gateway = KitsuBoosterCandidateGateway(
        clientReplying((_) async => http.Response('', 500)),
      );

      expect(
        gateway.drawCandidates(5, obtainedOn: moment),
        throwsA(isA<BoosterUnavailableException>()),
      );
    });

    test('signale l indisponibilité sur une réponse invalide', () {
      final gateway = KitsuBoosterCandidateGateway(
        clientReplying((_) async => http.Response('pas du json', 200)),
      );

      expect(
        gateway.drawCandidates(5, obtainedOn: moment),
        throwsA(isA<BoosterUnavailableException>()),
      );
    });

    test('abandonne une requête trop lente', () {
      final gateway = KitsuBoosterCandidateGateway(
        clientReplying((_) => Completer<http.Response>().future),
        requestTimeout: const Duration(milliseconds: 20),
      );

      expect(
        gateway.drawCandidates(2, obtainedOn: moment),
        throwsA(isA<BoosterUnavailableException>()),
      );
    });

    test('les raretés tirées suivent la distribution cible', () async {
      final offsets = <int>[];
      final gateway = KitsuBoosterCandidateGateway(
        clientReplying((request) async {
          offsets.add(int.parse(request.url.queryParameters['page[offset]']!));

          return jsonResponse(payload(id: offsets.length));
        }),
        random: Random(21),
      );

      for (var round = 0; round < 400; round++) {
        await gateway.drawCandidates(5, obtainedOn: moment);
      }

      final legendary = offsets.where((offset) => offset < 100).length;
      final common = offsets.where((offset) => offset >= 1500).length;

      expect(legendary / offsets.length, closeTo(0.03, 0.015));
      expect(common / offsets.length, closeTo(0.6, 0.05));
      expect(RarityRule.bands.length, 4);
    });
  });
}
