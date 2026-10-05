import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/card_rarity.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/dex_cubit.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/dex_filter.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/dex_state.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/text_folding.dart';

import 'ui_support.dart';

DexCubit loadedCubit() =>
    dexCubitOf(collection: MemoryCollection(sampleCollection))..load();

List<String> namesOf(DexCubit cubit) => [
  for (final card in cubit.state.visibleCards) card.name,
];

void main() {
  group('TextFolding', () {
    test('ignore la casse, les accents et les macrons', () {
      expect(TextFolding.fold('  ÉLISE Hōtarō Œuvre '), 'elise hotaro oeuvre');
    });

    test('laisse les autres écritures intactes', () {
      expect(TextFolding.fold('ナルト'), 'ナルト');
    });
  });

  group('DexFilter', () {
    test('actif seulement avec une recherche ou une rareté', () {
      expect(const DexFilter().isActive, isFalse);
      expect(const DexFilter(query: '  ').isActive, isFalse);
      expect(const DexFilter(query: 'a').isActive, isTrue);
      expect(const DexFilter(rarity: CardRarity.rare).isActive, isTrue);
      expect(const DexFilter(sort: DexSort.name).isActive, isFalse);
    });

    test('cleared garde le tri', () {
      final filter = const DexFilter(
        query: 'a',
        rarity: CardRarity.epic,
        sort: DexSort.name,
      ).cleared;

      expect(filter, const DexFilter(sort: DexSort.name));
    });
  });

  group('DexCubit, onglets et recherche', () {
    test('changer d\'onglet', () {
      final cubit = loadedCubit()..selectTab(DexTab.collection);

      expect(cubit.state.tab, DexTab.collection);
    });

    test('tri par défaut : plus récentes d\'abord, égalités par rareté', () {
      expect(namesOf(loadedCubit()), [
        'Zoro',
        'Light Yagami',
        'Élise Moreau',
        'Naruto Uzumaki',
        'Mikasa',
      ]);
    });

    test('recherche tolérante aux accents et à la casse', () {
      final cubit = loadedCubit()..search('ELISE');

      expect(namesOf(cubit), ['Élise Moreau']);
    });

    test('recherche par nom natif et par anime d\'origine', () {
      final cubit = loadedCubit()..search('ナルト');
      expect(namesOf(cubit), ['Naruto Uzumaki']);

      cubit.search('death');
      expect(namesOf(cubit), ['Light Yagami']);
    });

    test('recherche sans résultat', () {
      final cubit = loadedCubit()..search('zzz');

      expect(cubit.state.visibleCards, isEmpty);
      expect(cubit.state.filter.isActive, isTrue);
    });
  });

  group('DexCubit, rareté et tri', () {
    test('filtre par rareté puis retour à Toutes', () {
      final cubit = loadedCubit()..selectRarity(CardRarity.common);
      expect(namesOf(cubit), ['Naruto Uzumaki', 'Mikasa']);

      cubit.selectRarity(null);
      expect(cubit.state.visibleCards, hasLength(5));
    });

    test('rareté et recherche se combinent', () {
      final cubit = loadedCubit()
        ..selectRarity(CardRarity.common)
        ..search('mika');

      expect(namesOf(cubit), ['Mikasa']);
    });

    test('tri par rareté décroissante', () {
      final cubit = loadedCubit()..selectSort(DexSort.rarity);

      expect(namesOf(cubit), [
        'Zoro',
        'Light Yagami',
        'Élise Moreau',
        'Naruto Uzumaki',
        'Mikasa',
      ]);
    });

    test('tri par nom A → Z sans tenir compte des accents', () {
      final cubit = loadedCubit()..selectSort(DexSort.name);

      expect(namesOf(cubit), [
        'Élise Moreau',
        'Light Yagami',
        'Mikasa',
        'Naruto Uzumaki',
        'Zoro',
      ]);
    });

    test('tri par favoris décroissants', () {
      final cubit = loadedCubit()..selectSort(DexSort.favourites);

      expect(namesOf(cubit), [
        'Light Yagami',
        'Zoro',
        'Élise Moreau',
        'Mikasa',
        'Naruto Uzumaki',
      ]);
    });

    test('réinitialiser garde le tri et efface le reste', () {
      final cubit = loadedCubit()
        ..selectSort(DexSort.name)
        ..selectRarity(CardRarity.epic)
        ..search('x')
        ..resetFilters();

      expect(cubit.state.filter, const DexFilter(sort: DexSort.name));
      expect(cubit.state.visibleCards, hasLength(5));
    });

    test('recharger garde l\'onglet et les filtres', () {
      final cubit = loadedCubit()
        ..selectTab(DexTab.collection)
        ..selectRarity(CardRarity.rare)
        ..load();

      expect(cubit.state.tab, DexTab.collection);
      expect(cubit.state.filter.rarity, CardRarity.rare);
      expect(cubit.state.status, DexStatus.success);
    });
  });

  group('DexState', () {
    test('dernières cartes : celles du jour le plus récent', () {
      final names = [
        for (final card in loadedCubit().state.latestCards) card.name,
      ];

      expect(names, ['Zoro', 'Light Yagami']);
    });

    test('aucune carte : aucune dernière carte', () {
      expect(const DexState().latestCards, isEmpty);
    });
  });
}
