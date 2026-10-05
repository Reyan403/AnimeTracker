import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Animedex/data/rules/rarity_rule.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/card_rarity.dart';

void main() {
  group('RarityRule.of', () {
    test('classe selon la note moyenne', () {
      expect(RarityRule.of(averageRating: 85), CardRarity.legendary);
      expect(RarityRule.of(averageRating: 82.3), CardRarity.legendary);
      expect(RarityRule.of(averageRating: 81.5), CardRarity.epic);
      expect(RarityRule.of(averageRating: 81.2), CardRarity.epic);
      expect(RarityRule.of(averageRating: 78), CardRarity.rare);
      expect(RarityRule.of(averageRating: 73.5), CardRarity.rare);
      expect(RarityRule.of(averageRating: 73.49), CardRarity.common);
      expect(RarityRule.of(averageRating: 60), CardRarity.common);
    });

    test('traite une note absente comme commune', () {
      expect(RarityRule.of(), CardRarity.common);
    });

    test('élève d un cran un anime iconique', () {
      expect(
        RarityRule.of(averageRating: 60, popularityRank: 1),
        CardRarity.rare,
      );
      expect(
        RarityRule.of(averageRating: 78, popularityRank: 20),
        CardRarity.epic,
      );
      expect(
        RarityRule.of(averageRating: 81.5, popularityRank: 5),
        CardRarity.legendary,
      );
    });

    test('ne dépasse pas légendaire et ignore un anime peu populaire', () {
      expect(
        RarityRule.of(averageRating: 90, popularityRank: 1),
        CardRarity.legendary,
      );
      expect(
        RarityRule.of(averageRating: 60, popularityRank: 21),
        CardRarity.common,
      );
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

  group('RarityRule.offsetIn', () {
    test('reste dans la tranche de chaque rareté', () {
      final random = Random(7);

      for (final rarity in CardRarity.values) {
        final band = RarityRule.bands[rarity]!;

        for (var index = 0; index < 500; index++) {
          final offset = RarityRule.offsetIn(rarity, random);

          expect(offset, greaterThanOrEqualTo(band.start));
          expect(offset, lessThan(band.end));
        }
      }
    });

    test('couvre toutes les raretés sans chevauchement', () {
      final bands = RarityRule.bands.values.toList()
        ..sort((a, b) => a.start.compareTo(b.start));

      expect(bands.length, CardRarity.values.length);
      expect(bands.first.start, 0);

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
