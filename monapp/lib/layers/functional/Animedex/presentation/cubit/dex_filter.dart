import 'package:equatable/equatable.dart';

import '../../domain/entities/card_rarity.dart';

enum DexSort { recent, rarity, name, favourites }

class DexFilter extends Equatable {
  const DexFilter({this.query = '', this.rarity, this.sort = DexSort.recent});

  final String query;
  final CardRarity? rarity;
  final DexSort sort;

  bool get isActive => query.trim().isNotEmpty || rarity != null;

  DexFilter withQuery(String value) =>
      DexFilter(query: value, rarity: rarity, sort: sort);

  DexFilter withRarity(CardRarity? value) =>
      DexFilter(query: query, rarity: value, sort: sort);

  DexFilter withSort(DexSort value) =>
      DexFilter(query: query, rarity: rarity, sort: value);

  DexFilter get cleared => DexFilter(sort: sort);

  @override
  List<Object?> get props => [query, rarity, sort];
}
