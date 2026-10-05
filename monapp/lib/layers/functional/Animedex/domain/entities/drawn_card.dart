import 'package:equatable/equatable.dart';

import 'dex_card.dart';

class DrawnCard extends Equatable {
  const DrawnCard({required this.card, required this.isNew});

  final DexCard card;
  final bool isNew;

  @override
  List<Object?> get props => [card, isNew];
}
