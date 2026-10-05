import '../../domain/entities/dex_card.dart';
import 'dex_filter.dart';
import 'text_folding.dart';

abstract final class DexCollectionView {
  static List<DexCard> apply(List<DexCard> cards, DexFilter filter) {
    final needle = TextFolding.fold(filter.query);
    final indexed = <MapEntry<int, DexCard>>[
      for (var index = 0; index < cards.length; index++)
        if (_matches(cards[index], filter, needle))
          MapEntry(index, cards[index]),
    ]..sort((a, b) => _compare(a, b, filter.sort));

    return [for (final entry in indexed) entry.value];
  }

  static bool _matches(DexCard card, DexFilter filter, String needle) {
    if (filter.rarity != null && card.rarity != filter.rarity) {
      return false;
    }

    if (needle.isEmpty) {
      return true;
    }

    return [
      card.name,
      card.nativeName,
      card.animeTitle,
    ].any((text) => text != null && TextFolding.fold(text).contains(needle));
  }

  static int _compare(
    MapEntry<int, DexCard> a,
    MapEntry<int, DexCard> b,
    DexSort sort,
  ) {
    final result = switch (sort) {
      DexSort.recent => b.value.obtainedOn.compareTo(a.value.obtainedOn),
      DexSort.rarity => b.value.rarity.index.compareTo(a.value.rarity.index),
      DexSort.name => TextFolding.fold(
        a.value.name,
      ).compareTo(TextFolding.fold(b.value.name)),
      DexSort.favourites => b.value.favourites.compareTo(a.value.favourites),
    };

    return result != 0 ? result : a.key.compareTo(b.key);
  }
}
