import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Animedex/data/gateways/preferences_booster_schedule_gateway.dart';
import 'package:monapp/layers/functional/Animedex/data/gateways/preferences_dex_collection_gateway.dart';
import 'package:monapp/layers/functional/Animedex/data/models/dex_card_dto.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/card_rarity.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/dex_card.dart';
import 'package:monapp/layers/technical/Preferences/app_preferences.dart';
import 'package:monapp/layers/technical/Preferences/preferences_key.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../../../support/animedex_fakes.dart';

final DexCard full = DexCard(
  characterId: 21,
  name: 'Monkey D. Luffy',
  rarity: CardRarity.epic,
  favourites: 9000,
  obtainedOn: DateTime(2026, 10, 5, 9, 30),
  nativeName: 'モンキー・D・ルフィ',
  imageUrl: 'https://img/luffy.jpg',
  animeTitle: 'One Piece',
);

void main() {
  group('DexCardDto', () {
    test('encode puis decode redonne la même carte', () {
      expect(DexCardDto.fromJson(DexCardDto.toJson(full)), full);
    });

    test('decode une carte sans champs optionnels', () {
      final card = DexCardDto.fromJson({
        'characterId': 1,
        'name': 'X',
        'rarity': 'rare',
        'obtainedOn': '2026-10-05T00:00:00.000',
      })!;

      expect(card.favourites, 0);
      expect(card.nativeName, isNull);
      expect(card.imageUrl, isNull);
      expect(card.animeTitle, isNull);
    });

    test('tolère des types invalides sur les champs optionnels', () {
      final card = DexCardDto.fromJson({
        ...DexCardDto.toJson(full),
        'favourites': 'x',
        'native': 3,
        'image': 5,
        'anime': [],
      })!;

      expect(card.favourites, 0);
      expect(card.nativeName, isNull);
      expect(card.imageUrl, isNull);
      expect(card.animeTitle, isNull);
    });

    test('ignore sans planter une ancienne carte d anime', () {
      expect(
        DexCardDto.fromJson({
          'id': 21,
          'title': 'One Piece',
          'rarity': 'epic',
          'format': 'Série TV',
          'year': 1999,
          'episodes': 1100,
          'obtainedOn': '2026-10-05T09:30:00.000',
          'poster': 'https://img/poster.jpg',
          'genres': [
            {'slug': 'adventure', 'title': 'Aventure'},
          ],
        }),
        isNull,
      );
    });

    test('rejette les données corrompues', () {
      expect(DexCardDto.fromJson(null), isNull);
      expect(DexCardDto.fromJson('texte'), isNull);
      expect(DexCardDto.fromJson({'characterId': 'x'}), isNull);
      expect(
        DexCardDto.fromJson({...DexCardDto.toJson(full), 'rarity': 'mythic'}),
        isNull,
      );
      expect(
        DexCardDto.fromJson({...DexCardDto.toJson(full), 'obtainedOn': 'hier'}),
        isNull,
      );
      expect(
        DexCardDto.fromJson({...DexCardDto.toJson(full), 'name': null}),
        isNull,
      );
    });
  });

  group('PreferencesDexCollectionGateway', () {
    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
    });

    test('démarre vide', () async {
      final gateway = PreferencesDexCollectionGateway(
        await AppPreferences.open(),
      );

      expect(gateway.cards, isEmpty);
    });

    test('survit à la réouverture des préférences', () async {
      final first = PreferencesDexCollectionGateway(
        await AppPreferences.open(),
      );
      await first.addAll([full, buildDexCard(2)]);

      final reopened = PreferencesDexCollectionGateway(
        await AppPreferences.open(),
      );

      expect(reopened.cards, [full, buildDexCard(2)]);
    });

    test('n ajoute pas deux fois le même anime', () async {
      final gateway = PreferencesDexCollectionGateway(
        await AppPreferences.open(),
      );

      await gateway.addAll([full, buildDexCard(2), buildDexCard(2)]);
      await gateway.addAll([full, buildDexCard(3)]);

      expect(gateway.cards.map((card) => card.characterId), [21, 2, 3]);
    });

    test('ignore les données corrompues', () async {
      final preferences = await AppPreferences.open();
      await preferences.writeString(PreferencesKey.dex, '{pas du json');

      expect(PreferencesDexCollectionGateway(preferences).cards, isEmpty);
    });

    test('ignore un contenu qui n est pas une liste', () async {
      final preferences = await AppPreferences.open();
      await preferences.writeString(PreferencesKey.dex, '{"a":1}');

      expect(PreferencesDexCollectionGateway(preferences).cards, isEmpty);
    });

    test('écarte les entrées invalides et garde les valides', () async {
      final preferences = await AppPreferences.open();
      await preferences.writeString(
        PreferencesKey.dex,
        '[{"characterId":1,"name":"A","rarity":"epic",'
        '"obtainedOn":"2026-10-05T00:00:00.000"},{"id":"x"},5]',
      );

      final cards = PreferencesDexCollectionGateway(preferences).cards;

      expect(cards.single.characterId, 1);
    });

    test('ignore l ancienne collection d animes sans exception', () async {
      final preferences = await AppPreferences.open();
      await preferences.writeString(
        PreferencesKey.dex,
        '[{"id":1,"title":"A","rarity":"epic","format":"TV","year":2000,'
        '"episodes":12,"obtainedOn":"2026-10-05T00:00:00.000","genres":[]}]',
      );
      final gateway = PreferencesDexCollectionGateway(preferences);

      expect(gateway.cards, isEmpty);

      await gateway.addAll([full]);

      expect(gateway.cards, [full]);
    });

    test('la liste exposée n est pas modifiable', () async {
      final gateway = PreferencesDexCollectionGateway(
        await AppPreferences.open(),
      );

      expect(() => gateway.cards.add(full), throwsUnsupportedError);
    });
  });

  group('PreferencesBoosterScheduleGateway', () {
    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
    });

    test('ne connaît aucun jour au départ', () async {
      final gateway = PreferencesBoosterScheduleGateway(
        await AppPreferences.open(),
      );

      expect(gateway.lastOpenedDay, isNull);
    });

    test('mémorise le dernier jour ouvert', () async {
      final gateway = PreferencesBoosterScheduleGateway(
        await AppPreferences.open(),
      );

      await gateway.markOpened('2026-10-05');

      expect(
        PreferencesBoosterScheduleGateway(await AppPreferences.open())
            .lastOpenedDay,
        '2026-10-05',
      );
    });
  });
}
