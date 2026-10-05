import '../entities/dex_card.dart';

abstract interface class DexCollectionGateway {
  List<DexCard> get cards;

  Future<void> addAll(List<DexCard> cards);
}
