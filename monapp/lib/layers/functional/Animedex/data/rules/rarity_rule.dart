import 'dart:math';

import '../../domain/entities/card_rarity.dart';

abstract final class RarityRule {
  static const double legendaryRating = 82.3;
  static const double epicRating = 81.2;
  static const double rareRating = 73.5;
  static const int iconicPopularityRank = 20;

  static const Map<CardRarity, double> probabilities = {
    CardRarity.common: 0.60,
    CardRarity.rare: 0.28,
    CardRarity.epic: 0.09,
    CardRarity.legendary: 0.03,
  };

  static const Map<CardRarity, ({int start, int end})> bands = {
    CardRarity.legendary: (start: 0, end: 100),
    CardRarity.epic: (start: 100, end: 400),
    CardRarity.rare: (start: 400, end: 1500),
    CardRarity.common: (start: 1500, end: 3300),
  };

  static CardRarity of({double? averageRating, int? popularityRank}) {
    final base = _byRating(averageRating);
    final iconic =
        popularityRank != null && popularityRank <= iconicPopularityRank;

    if (!iconic || base == CardRarity.legendary) {
      return base;
    }

    return CardRarity.values[base.index + 1];
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

  static int offsetIn(CardRarity rarity, Random random) {
    final band = bands[rarity]!;

    return band.start + random.nextInt(band.end - band.start);
  }

  static CardRarity _byRating(double? rating) {
    if (rating == null) {
      return CardRarity.common;
    }

    if (rating >= legendaryRating) {
      return CardRarity.legendary;
    }

    if (rating >= epicRating) {
      return CardRarity.epic;
    }

    return rating >= rareRating ? CardRarity.rare : CardRarity.common;
  }
}
