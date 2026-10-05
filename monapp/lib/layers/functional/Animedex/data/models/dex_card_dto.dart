import '../../domain/entities/card_rarity.dart';
import '../../domain/entities/dex_card.dart';

abstract final class DexCardDto {
  static const String characterKey = 'characterId';

  static Map<String, dynamic> toJson(DexCard card) => {
    characterKey: card.characterId,
    'name': card.name,
    'native': card.nativeName,
    'rarity': card.rarity.name,
    'favourites': card.favourites,
    'obtainedOn': card.obtainedOn.toIso8601String(),
    'image': card.imageUrl,
    'anime': card.animeTitle,
  };

  static DexCard? fromJson(Object? source) {
    if (source is! Map) {
      return null;
    }

    final id = source[characterKey];
    final name = source['name'];
    final obtainedOn = DateTime.tryParse('${source['obtainedOn']}');
    final rarity = CardRarity.values.asNameMap()[source['rarity']];

    if (id is! int || name is! String || obtainedOn == null || rarity == null) {
      return null;
    }

    return DexCard(
      characterId: id,
      name: name,
      rarity: rarity,
      favourites: source['favourites'] is int ? source['favourites'] as int : 0,
      obtainedOn: obtainedOn,
      nativeName: _textOf(source['native']),
      imageUrl: _textOf(source['image']),
      animeTitle: _textOf(source['anime']),
    );
  }

  static String? _textOf(Object? value) => value is String ? value : null;
}
