import 'dart:async';
import 'dart:math';

import '../../../../technical/KitsuApi/kitsu_client.dart';
import '../../domain/entities/dex_card.dart';
import '../../domain/gateways/booster_candidate_gateway.dart';
import '../models/booster_candidate_dto.dart';
import '../rules/rarity_rule.dart';

class KitsuBoosterCandidateGateway implements BoosterCandidateGateway {
  KitsuBoosterCandidateGateway(
    this._client, {
    Random? random,
    this.requestTimeout = defaultTimeout,
  }) : _random = random ?? Random();

  static const int minimumFollowers = 2000;
  static const Duration defaultTimeout = Duration(milliseconds: 4000);

  final KitsuClient _client;
  final Duration requestTimeout;
  final Random _random;

  @override
  Future<List<DexCard>> drawCandidates(
    int count, {
    required DateTime obtainedOn,
    Set<int> excludedIds = const {},
  }) async {
    final drawn = await Future.wait([
      for (final offset in _offsets(count)) _fetchAt(offset, obtainedOn),
    ]);
    final seen = {...excludedIds};
    final cards = [
      for (final card in drawn)
        if (card != null && seen.add(card.animeId)) card,
    ];

    if (cards.isEmpty) {
      throw const BoosterUnavailableException();
    }

    return cards;
  }

  List<int> _offsets(int count) {
    final used = <int>{};

    for (var slot = 0; slot < count; slot++) {
      final rarity = RarityRule.roll(_random);
      var offset = RarityRule.offsetIn(rarity, _random);

      for (var retry = 0; retry < 5 && !used.add(offset); retry++) {
        offset = RarityRule.offsetIn(rarity, _random);
      }
    }

    return used.toList();
  }

  Future<DexCard?> _fetchAt(int offset, DateTime obtainedOn) async {
    try {
      final json = await _client
          .getJson(
            'anime?filter%5BuserCount%5D=$minimumFollowers..'
            '&filter%5Bsubtype%5D=TV,movie&sort=ratingRank'
            '&page%5Blimit%5D=1&page%5Boffset%5D=$offset&include=categories'
            '&fields%5Banime%5D=canonicalTitle,subtype,startDate,episodeCount,'
            'posterImage,averageRating,popularityRank,categories'
            '&fields%5Bcategories%5D=title,slug',
          )
          .timeout(requestTimeout);

      return BoosterCandidateDto.fromJson(json, obtainedOn: obtainedOn);
    } on Object {
      return null;
    }
  }
}
