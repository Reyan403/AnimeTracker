import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:monapp/layers/technical/KitsuApi/kitsu_client.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/card_rarity.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/dex_card.dart';
import 'package:monapp/layers/functional/Animedex/domain/gateways/booster_candidate_gateway.dart';
import 'package:monapp/layers/functional/Animedex/domain/gateways/booster_schedule_gateway.dart';
import 'package:monapp/layers/functional/Animedex/domain/gateways/dex_collection_gateway.dart';

DexCard buildDexCard(
  int animeId, {
  CardRarity rarity = CardRarity.common,
  DateTime? obtainedOn,
  String? title,
}) => DexCard(
  animeId: animeId,
  title: title ?? 'Anime $animeId',
  rarity: rarity,
  format: 'Série TV',
  year: 2020,
  episodeCount: 12,
  obtainedOn: obtainedOn ?? DateTime(2026, 10, 5),
);

class FakeDexCollectionGateway implements DexCollectionGateway {
  FakeDexCollectionGateway([List<DexCard>? initial]) : _cards = [...?initial];

  final List<DexCard> _cards;
  int additions = 0;

  @override
  List<DexCard> get cards => List.unmodifiable(_cards);

  @override
  Future<void> addAll(List<DexCard> cards) async {
    additions++;
    _cards.addAll(cards);
  }
}

class FakeBoosterScheduleGateway implements BoosterScheduleGateway {
  FakeBoosterScheduleGateway([this.lastOpenedDay]);

  @override
  String? lastOpenedDay;

  @override
  Future<void> markOpened(String day) async => lastOpenedDay = day;
}

class FakeBoosterCandidateGateway implements BoosterCandidateGateway {
  FakeBoosterCandidateGateway(List<List<DexCard>> batches)
    : _batches = [...batches];

  FakeBoosterCandidateGateway.unavailable() : _batches = [];

  final List<List<DexCard>> _batches;
  final List<Set<int>> receivedExclusions = [];
  final List<int> requestedCounts = [];

  int get calls => requestedCounts.length;

  @override
  Future<List<DexCard>> drawCandidates(
    int count, {
    required DateTime obtainedOn,
    Set<int> excludedIds = const {},
  }) async {
    requestedCounts.add(count);
    receivedExclusions.add(excludedIds);

    if (_batches.isEmpty) {
      throw const BoosterUnavailableException();
    }

    return _batches.removeAt(0);
  }
}

Map<String, dynamic> payload({
  int id = 7,
  String? title = 'Cowboy Bebop',
  Object? rating = '88.5',
  int? popularityRank = 400,
  List<Map<String, dynamic>>? included,
  List<Map<String, dynamic>>? links,
}) => {
  'data': [
    {
      'id': '$id',
      'attributes': {
        'canonicalTitle': title,
        'subtype': 'TV',
        'startDate': '1998-04-03',
        'episodeCount': 26,
        'averageRating': rating,
        'popularityRank': popularityRank,
        'posterImage': {'small': 'https://img/$id.jpg'},
      },
      'relationships': {
        'categories': {
          'data':
              links ??
              [
                {'type': 'categories', 'id': '1'},
                {'type': 'categories', 'id': '99'},
              ],
        },
      },
    },
  ],
  'included':
      included ??
      [
        {
          'id': '1',
          'type': 'categories',
          'attributes': {'slug': 'space', 'title': 'Espace'},
        },
        {'id': '5', 'type': 'anime', 'attributes': <String, dynamic>{}},
      ],
};

KitsuClient clientReplying(
  Future<http.Response> Function(http.Request request) handler,
) => KitsuClient(MockClient(handler));

http.Response jsonResponse(Map<String, dynamic> body) =>
    http.Response(jsonEncode(body), 200);
