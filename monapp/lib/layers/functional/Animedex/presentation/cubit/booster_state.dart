import 'package:equatable/equatable.dart';

import '../../domain/entities/drawn_card.dart';

enum BoosterStatus { idle, opening, revealed, alreadyOpened, failure }

class BoosterState extends Equatable {
  const BoosterState({
    this.status = BoosterStatus.idle,
    this.cards = const [],
    this.revealedCount = 0,
  });

  final BoosterStatus status;
  final List<DrawnCard> cards;
  final int revealedCount;

  bool get isComplete => cards.isNotEmpty && revealedCount >= cards.length;

  int get newCount => cards.where((drawn) => drawn.isNew).length;

  int get duplicateCount => cards.length - newCount;

  DrawnCard? get current =>
      revealedCount == 0 ? null : cards[revealedCount - 1];

  BoosterState copyWith({int? revealedCount}) => BoosterState(
    status: status,
    cards: cards,
    revealedCount: revealedCount ?? this.revealedCount,
  );

  @override
  List<Object?> get props => [status, cards, revealedCount];
}
