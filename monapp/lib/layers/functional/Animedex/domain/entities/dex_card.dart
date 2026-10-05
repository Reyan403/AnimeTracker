import 'package:equatable/equatable.dart';

import 'card_rarity.dart';

class DexCard extends Equatable {
  const DexCard({
    required this.characterId,
    required this.name,
    required this.rarity,
    required this.favourites,
    required this.obtainedOn,
    this.nativeName,
    this.imageUrl,
    this.animeTitle,
  });

  final int characterId;
  final String name;
  final CardRarity rarity;
  final int favourites;
  final DateTime obtainedOn;
  final String? nativeName;
  final String? imageUrl;
  final String? animeTitle;

  @override
  List<Object?> get props => [
    characterId,
    name,
    rarity,
    favourites,
    obtainedOn,
    nativeName,
    imageUrl,
    animeTitle,
  ];
}
