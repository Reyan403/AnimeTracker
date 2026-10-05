import '../entities/dex_card.dart';
import '../gateways/dex_collection_gateway.dart';

class LoadDexUseCase {
  const LoadDexUseCase(this._collection);

  final DexCollectionGateway _collection;

  List<DexCard> call() => [..._collection.cards]..sort(_byRarityThenRecency);

  static int _byRarityThenRecency(DexCard a, DexCard b) {
    final byRarity = b.rarity.index.compareTo(a.rarity.index);

    return byRarity != 0 ? byRarity : b.obtainedOn.compareTo(a.obtainedOn);
  }
}
