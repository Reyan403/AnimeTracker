import 'package:equatable/equatable.dart';

import '../../domain/entities/booster_availability.dart';
import '../../domain/entities/card_rarity.dart';
import '../../domain/entities/dex_card.dart';

enum DexStatus { loading, success, empty, failure }

class DexState extends Equatable {
  const DexState({
    this.status = DexStatus.loading,
    this.cards = const [],
    this.availability,
  });

  final DexStatus status;
  final List<DexCard> cards;
  final BoosterAvailability? availability;

  bool get isBoosterAvailable => availability?.isAvailable ?? false;

  int countOf(CardRarity rarity) =>
      cards.where((card) => card.rarity == rarity).length;

  @override
  List<Object?> get props => [status, cards, availability];
}
