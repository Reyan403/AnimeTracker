import 'dart:math';

import '../../../../technical/AniListApi/anilist_client.dart';
import '../../domain/entities/dex_card.dart';
import '../../domain/gateways/booster_candidate_gateway.dart';
import '../models/ani_list_character_dto.dart';
import '../rules/rarity_rule.dart';

class AniListBoosterCandidateGateway implements BoosterCandidateGateway {
  AniListBoosterCandidateGateway(
    this._client, {
    Random? random,
    this.requestTimeout = defaultTimeout,
  }) : _random = random ?? Random();

  static const Duration defaultTimeout = Duration(milliseconds: 4000);
  static const int maxPlacementRetries = 5;

  static const String _fields = '''
characters(sort: FAVOURITES_DESC) {
  id
  name { full native }
  image { large }
  favourites
  media(perPage: 1, sort: POPULARITY_DESC) {
    nodes { title { romaji english } }
  }
}
''';

  final AniListClient _client;
  final Duration requestTimeout;
  final Random _random;

  @override
  Future<List<DexCard>> drawCandidates(
    int count, {
    required DateTime obtainedOn,
    Set<int> excludedIds = const {},
  }) async {
    final json = await _fetch(buildQuery(_pages(count)));
    final seen = {...excludedIds};
    final cards = [
      for (final card in AniListCharacterDto.fromJson(
        json,
        obtainedOn: obtainedOn,
      ))
        if (seen.add(card.characterId)) card,
    ];

    if (cards.isEmpty) {
      throw const BoosterUnavailableException();
    }

    return cards;
  }

  static String buildQuery(List<int> pages) => [
    'query {',
    for (var slot = 0; slot < pages.length; slot++)
      'c$slot: Page(page: ${pages[slot]}, perPage: 1) { $_fields }',
    '}',
  ].join('\n');

  List<int> _pages(int count) {
    final used = <int>{};

    for (var slot = 0; slot < count; slot++) {
      final rarity = RarityRule.roll(_random);
      var page = RarityRule.pageIn(rarity, _random);

      for (
        var retry = 0;
        retry < maxPlacementRetries && !used.add(page);
        retry++
      ) {
        page = RarityRule.pageIn(rarity, _random);
      }
    }

    return used.toList();
  }

  Future<Map<String, dynamic>> _fetch(String query) async {
    try {
      return await _client.query(query).timeout(requestTimeout);
    } on Object {
      throw const BoosterUnavailableException();
    }
  }
}
