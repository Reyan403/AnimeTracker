import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Animedex/data/models/ani_list_character_dto.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/card_rarity.dart';

import 'domain_data_anilist_support.dart';

final DateTime moment = DateTime(2026, 10, 5, 10);

void main() {
  group('AniListCharacterDto', () {
    test('construit une carte complète', () {
      final cards = AniListCharacterDto.fromJson(
        characterResponse([characterPage(id: 7)]),
        obtainedOn: moment,
      );

      expect(cards.single.characterId, 7);
      expect(cards.single.name, 'Spike Spiegel');
      expect(cards.single.nativeName, 'スパイク');
      expect(cards.single.favourites, 20000);
      expect(cards.single.rarity, CardRarity.legendary);
      expect(cards.single.obtainedOn, moment);
      expect(cards.single.imageUrl, 'https://img/7.png');
      expect(cards.single.animeTitle, 'Cowboy Bebop (EN)');
    });

    test('déduit la rareté des favoris', () {
      final cards = AniListCharacterDto.fromJson(
        characterResponse([
          characterPage(id: 1, favourites: 6000),
          characterPage(id: 2, favourites: 2000),
          characterPage(id: 3, favourites: 300),
        ]),
        obtainedOn: moment,
      );

      expect(cards.map((card) => card.rarity), [
        CardRarity.epic,
        CardRarity.rare,
        CardRarity.common,
      ]);
    });

    test('préfère le titre anglais puis retombe sur le romaji', () {
      final cards = AniListCharacterDto.fromJson(
        characterResponse([
          characterPage(id: 1, english: null, romaji: 'Romaji'),
          characterPage(id: 2, english: '  ', romaji: 'Autre'),
        ]),
        obtainedOn: moment,
      );

      expect(cards.map((card) => card.animeTitle), ['Romaji', 'Autre']);
    });

    test('tolère l absence d anime, de nom natif et de favoris', () {
      final page = characterPage(id: 1);
      final character = (page['characters'] as List).first as Map;
      character
        ..['media'] = {'nodes': <Object>[]}
        ..['favourites'] = null
        ..['name'] = {'full': 'Solo'};

      final card = AniListCharacterDto.fromJson(
        characterResponse([page]),
        obtainedOn: moment,
      ).single;

      expect(card.animeTitle, isNull);
      expect(card.nativeName, isNull);
      expect(card.favourites, 0);
      expect(card.rarity, CardRarity.common);
    });

    test('ignore l image par défaut', () {
      final cards = AniListCharacterDto.fromJson(
        characterResponse([
          characterPage(
            id: 1,
            image: 'https://s4.anilist.co/character/large/default.jpg',
          ),
        ]),
        obtainedOn: moment,
      );

      expect(cards.single.imageUrl, isNull);
    });

    test('ignore les alias vides ou invalides', () {
      final cards = AniListCharacterDto.fromJson({
        'data': {
          'c0': null,
          'c1': {'characters': <Object>[]},
          'c2': {
            'characters': ['x'],
          },
          'c3': {
            'characters': [
              {'id': 'x'},
            ],
          },
          'c4': {
            'characters': [
              {
                'id': 9,
                'name': {'full': ''},
              },
            ],
          },
          'c5': characterPage(id: 5),
        },
      }, obtainedOn: moment);

      expect(cards.map((card) => card.characterId), [5]);
    });

    test('renvoie une liste vide sans données', () {
      expect(AniListCharacterDto.fromJson({}, obtainedOn: moment), isEmpty);
      expect(
        AniListCharacterDto.fromJson({'data': null}, obtainedOn: moment),
        isEmpty,
      );
    });
  });
}
