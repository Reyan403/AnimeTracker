import 'dart:math';

import '../../domain/entities/card_rarity.dart';

abstract final class RarityRule {
  static const int legendaryFavourites = 14000;
  static const int epicFavourites = 5400;
  static const int rareFavourites = 1100;

  static const Map<CardRarity, double> probabilities = {
    CardRarity.common: 0.60,
    CardRarity.rare: 0.28,
    CardRarity.epic: 0.09,
    CardRarity.legendary: 0.03,
  };

  static const Map<CardRarity, ({int start, int end})> bands = {
    CardRarity.legendary: (start: 1, end: 61),
    CardRarity.epic: (start: 61, end: 301),
    CardRarity.rare: (start: 301, end: 1501),
    CardRarity.common: (start: 1501, end: 5001),
  };

  static CardRarity of(int favourites) {
    if (favourites >= legendaryFavourites) {
      return CardRarity.legendary;
    }

    if (favourites >= epicFavourites) {
      return CardRarity.epic;
    }

    return favourites >= rareFavourites ? CardRarity.rare : CardRarity.common;
  }

  static CardRarity roll(Random random) {
    var remaining = random.nextDouble();

    for (final entry in probabilities.entries) {
      remaining -= entry.value;

      if (remaining < 0) {
        return entry.key;
      }
    }

    return CardRarity.common;
  }

  static int pageIn(CardRarity rarity, Random random) {
    final band = bands[rarity]!;

    return band.start + random.nextInt(band.end - band.start);
  }
}
