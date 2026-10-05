import 'package:equatable/equatable.dart';

import '../../domain/entities/booster_availability.dart';
import '../../domain/entities/card_rarity.dart';
import '../../domain/entities/dex_card.dart';
import 'dex_collection_view.dart';
import 'dex_filter.dart';

enum DexStatus { loading, success, empty, failure }

enum DexTab { booster, collection }

class DexState extends Equatable {
  const DexState({
    this.status = DexStatus.loading,
    this.cards = const [],
    this.availability,
    this.tab = DexTab.booster,
    this.filter = const DexFilter(),
  });

  final DexStatus status;
  final List<DexCard> cards;
  final BoosterAvailability? availability;
  final DexTab tab;
  final DexFilter filter;

  bool get isBoosterAvailable => availability?.isAvailable ?? false;

  int countOf(CardRarity rarity) =>
      cards.where((card) => card.rarity == rarity).length;

  List<DexCard> get visibleCards => DexCollectionView.apply(cards, filter);

  List<DexCard> get latestCards {
    if (cards.isEmpty) {
      return const [];
    }

    final newest = cards
        .map((card) => card.obtainedOn)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    return [
      for (final card in cards)
        if (_isSameDay(card.obtainedOn, newest)) card,
    ];
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  DexState copyWith({
    DexStatus? status,
    List<DexCard>? cards,
    BoosterAvailability? availability,
    DexTab? tab,
    DexFilter? filter,
  }) => DexState(
    status: status ?? this.status,
    cards: cards ?? this.cards,
    availability: availability ?? this.availability,
    tab: tab ?? this.tab,
    filter: filter ?? this.filter,
  );

  @override
  List<Object?> get props => [status, cards, availability, tab, filter];
}
