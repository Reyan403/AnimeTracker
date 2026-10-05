import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Animedex/data/models/booster_candidate_dto.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/card_rarity.dart';

import '../../../support/animedex_fakes.dart';

final DateTime moment = DateTime(2026, 10, 5, 10);

void main() {
  group('BoosterCandidateDto', () {
    test('construit une carte complète', () {
      final card = BoosterCandidateDto.fromJson(payload(), obtainedOn: moment)!;

      expect(card.animeId, 7);
      expect(card.title, 'Cowboy Bebop');
      expect(card.rarity, CardRarity.legendary);
      expect(card.format, 'Série TV');
      expect(card.year, 1998);
      expect(card.episodeCount, 26);
      expect(card.obtainedOn, moment);
      expect(card.posterUrl, 'https://img/7.jpg');
      expect(card.genres.single.slug, 'space');
    });

    test('lit une note exprimée en nombre', () {
      final card = BoosterCandidateDto.fromJson(
        payload(rating: 75),
        obtainedOn: moment,
      )!;

      expect(card.rarity, CardRarity.rare);
    });

    test('traite une note absente comme commune', () {
      final card = BoosterCandidateDto.fromJson(
        payload(rating: null, popularityRank: null),
        obtainedOn: moment,
      )!;

      expect(card.rarity, CardRarity.common);
    });

    test('applique le bonus des animes iconiques', () {
      final card = BoosterCandidateDto.fromJson(
        payload(rating: '78', popularityRank: 3),
        obtainedOn: moment,
      )!;

      expect(card.rarity, CardRarity.epic);
    });

    test('ignore une réponse vide ou sans titre', () {
      expect(
        BoosterCandidateDto.fromJson({'data': <Object>[]}, obtainedOn: moment),
        isNull,
      );
      expect(BoosterCandidateDto.fromJson({}, obtainedOn: moment), isNull);
      expect(
        BoosterCandidateDto.fromJson(payload(title: ''), obtainedOn: moment),
        isNull,
      );
    });

    test('tolère l absence de catégories', () {
      final json = payload()..remove('included');
      (json['data'] as List).first.remove('relationships');

      expect(
        BoosterCandidateDto.fromJson(json, obtainedOn: moment)!.genres,
        isEmpty,
      );
    });

    test('ignore une catégorie sans titre', () {
      final card = BoosterCandidateDto.fromJson(
        payload(
          included: [
            {
              'id': '1',
              'type': 'categories',
              'attributes': {'slug': 'space'},
            },
          ],
        ),
        obtainedOn: moment,
      )!;

      expect(card.genres, isEmpty);
    });
  });
}
