import 'package:monapp/layers/functional/Animedex/domain/entities/card_rarity.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/dex_card.dart';
import 'package:monapp/layers/functional/Animedex/domain/gateways/booster_candidate_gateway.dart';
import 'package:monapp/layers/functional/Animedex/domain/gateways/booster_schedule_gateway.dart';
import 'package:monapp/layers/functional/Animedex/domain/gateways/dex_collection_gateway.dart';

DexCard buildDexCard(
  int id, {
  CardRarity rarity = CardRarity.common,
  DateTime? obtainedOn,
  String? name,
  int favourites = 1000,
  String? animeTitle,
  String? nativeName,
  String? imageUrl,
}) => DexCard(
  characterId: id,
  name: name ?? 'Personnage $id',
  rarity: rarity,
  favourites: favourites,
  obtainedOn: obtainedOn ?? DateTime(2026, 10, 5),
  nativeName: nativeName,
  imageUrl: imageUrl ?? 'https://img/$id.jpg',
  animeTitle: animeTitle ?? 'Anime $id',
);

class FakeDexCollectionGateway implements DexCollectionGateway {
  FakeDexCollectionGateway([List<DexCard>? initial]) : _cards = [...?initial];

  final List<DexCard> _cards;
  int additions = 0;

  @override
  List<DexCard> get cards => List.unmodifiable(_cards);

  @override
  Future<void> addAll(List<DexCard> cards) async {
    additions++;
    _cards.addAll(cards);
  }
}

class FakeBoosterScheduleGateway implements BoosterScheduleGateway {
  FakeBoosterScheduleGateway([this.lastOpenedDay]);

  @override
  String? lastOpenedDay;

  @override
  Future<void> markOpened(String day) async => lastOpenedDay = day;
}

class FakeBoosterCandidateGateway implements BoosterCandidateGateway {
  FakeBoosterCandidateGateway(List<List<DexCard>> batches)
    : _batches = [...batches];

  FakeBoosterCandidateGateway.unavailable() : _batches = [];

  final List<List<DexCard>> _batches;
  final List<Set<int>> receivedExclusions = [];
  final List<int> requestedCounts = [];

  int get calls => requestedCounts.length;

  @override
  Future<List<DexCard>> drawCandidates(
    int count, {
    required DateTime obtainedOn,
    Set<int> excludedIds = const {},
  }) async {
    requestedCounts.add(count);
    receivedExclusions.add(excludedIds);

    if (_batches.isEmpty) {
      throw const BoosterUnavailableException();
    }

    return _batches.removeAt(0);
  }
}
