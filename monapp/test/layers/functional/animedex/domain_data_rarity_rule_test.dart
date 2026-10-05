import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Animedex/data/rules/rarity_rule.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/card_rarity.dart';

void main() {
  group('RarityRule.of', () {
    test('classe selon le nombre de favoris', () {
      expect(RarityRule.of(39000), CardRarity.legendary);
      expect(RarityRule.of(14000), CardRarity.legendary);
      expect(RarityRule.of(13999), CardRarity.epic);
      expect(RarityRule.of(5400), CardRarity.epic);
      expect(RarityRule.of(5399), CardRarity.rare);
      expect(RarityRule.of(1100), CardRarity.rare);
      expect(RarityRule.of(1099), CardRarity.common);
      expect(RarityRule.of(0), CardRarity.common);
    });
  });

  group('RarityRule.roll', () {
    test('respecte les probabilités cibles', () {
      final random = Random(42);
      const draws = 20000;
      final counts = {for (final rarity in CardRarity.values) rarity: 0};

      for (var index = 0; index < draws; index++) {
        final rarity = RarityRule.roll(random);
        counts[rarity] = counts[rarity]! + 1;
      }

      for (final entry in RarityRule.probabilities.entries) {
        expect(counts[entry.key]! / draws, closeTo(entry.value, 0.015));
      }
    });

    test('les probabilités totalisent 1', () {
      final total = RarityRule.probabilities.values.reduce((a, b) => a + b);

      expect(total, closeTo(1, 1e-9));
    });

    test('retombe sur commune si le tirage dépasse le total', () {
      expect(RarityRule.roll(_FixedRandom(0.9999999)), CardRarity.legendary);
      expect(RarityRule.roll(_FixedRandom(1.5)), CardRarity.common);
    });

    test('choisit la bonne borne', () {
      expect(RarityRule.roll(_FixedRandom(0)), CardRarity.common);
      expect(RarityRule.roll(_FixedRandom(0.6)), CardRarity.rare);
      expect(RarityRule.roll(_FixedRandom(0.89)), CardRarity.epic);
      expect(RarityRule.roll(_FixedRandom(0.98)), CardRarity.legendary);
    });
  });

  group('RarityRule.pageIn', () {
    test('reste dans la tranche de rang de chaque rareté', () {
      final random = Random(7);

      for (final rarity in CardRarity.values) {
        final band = RarityRule.bands[rarity]!;

        for (var index = 0; index < 500; index++) {
          final page = RarityRule.pageIn(rarity, random);

          expect(page, greaterThanOrEqualTo(band.start));
          expect(page, lessThan(band.end));
        }
      }
    });

    test('couvre les rangs 1 à 5000 sans chevauchement', () {
      final bands = RarityRule.bands.values.toList()
        ..sort((a, b) => a.start.compareTo(b.start));

      expect(bands.length, CardRarity.values.length);
      expect(bands.first.start, 1);
      expect(bands.last.end, 5001);

      for (var index = 1; index < bands.length; index++) {
        expect(bands[index].start, bands[index - 1].end);
      }
    });
  });
}

class _FixedRandom implements Random {
  _FixedRandom(this.value);

  final double value;

  @override
  bool nextBool() => false;

  @override
  double nextDouble() => value;

  @override
  int nextInt(int max) => 0;
}
