import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../domain/entities/card_rarity.dart';

extension CardRarityStyle on CardRarity {
  int get stars => index + 1;

  bool get isHolographic => this != CardRarity.common;

  bool get isLegendary => this == CardRarity.legendary;

  double get shineIntensity => switch (this) {
    CardRarity.common => 0,
    CardRarity.rare => 0.22,
    CardRarity.epic => 0.34,
    CardRarity.legendary => 0.48,
  };

  int get sparkleCount => switch (this) {
    CardRarity.common => 0,
    CardRarity.rare => 10,
    CardRarity.epic => 20,
    CardRarity.legendary => 34,
  };

  Color color(AppPalette palette) => switch (this) {
    CardRarity.common => palette.rarityCommon,
    CardRarity.rare => palette.rarityRare,
    CardRarity.epic => palette.rarityEpic,
    CardRarity.legendary => palette.rarityLegendary,
  };

  String label(AppLocalizations l10n) => switch (this) {
    CardRarity.common => l10n.dexRarityCommon,
    CardRarity.rare => l10n.dexRarityRare,
    CardRarity.epic => l10n.dexRarityEpic,
    CardRarity.legendary => l10n.dexRarityLegendary,
  };
}
