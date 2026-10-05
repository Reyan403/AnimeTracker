import 'package:monapp/layers/functional/Animedex/domain/entities/card_rarity.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/dex_card.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/drawn_card.dart';
import 'package:monapp/layers/functional/Animedex/domain/gateways/booster_schedule_gateway.dart';
import 'package:monapp/layers/functional/Animedex/domain/gateways/dex_collection_gateway.dart';
import 'package:monapp/layers/functional/Animedex/domain/use_cases/check_booster_availability_use_case.dart';
import 'package:monapp/layers/functional/Animedex/domain/use_cases/load_dex_use_case.dart';
import 'package:monapp/layers/functional/Animedex/domain/use_cases/open_booster_use_case.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/booster_cubit.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/dex_cubit.dart';

final DateTime fixedNow = DateTime(2026, 10, 5, 20, 30, 15);

DexCard cardOf(
  int id, {
  CardRarity rarity = CardRarity.common,
  String? title,
}) => DexCard(
  animeId: id,
  title: title ?? 'Anime $id',
  rarity: rarity,
  format: 'TV',
  year: 2000 + id,
  episodeCount: 12,
  obtainedOn: fixedNow,
);

DrawnCard drawnOf(
  int id, {
  CardRarity rarity = CardRarity.common,
  bool isNew = true,
}) => DrawnCard(
  card: cardOf(id, rarity: rarity),
  isNew: isNew,
);

class MemoryCollection implements DexCollectionGateway {
  MemoryCollection([List<DexCard> initial = const []]) : _cards = [...initial];

  final List<DexCard> _cards;

  @override
  List<DexCard> get cards => _cards;

  @override
  Future<void> addAll(List<DexCard> cards) async => _cards.addAll(cards);
}

class ThrowingCollection implements DexCollectionGateway {
  @override
  List<DexCard> get cards => throw StateError('broken');

  @override
  Future<void> addAll(List<DexCard> cards) async {}
}

class MemorySchedule implements BoosterScheduleGateway {
  MemorySchedule([this.lastOpenedDay]);

  @override
  String? lastOpenedDay;

  @override
  Future<void> markOpened(String day) async => lastOpenedDay = day;
}

DexCubit dexCubitOf({
  DexCollectionGateway? collection,
  bool openedToday = false,
}) => DexCubit(
  LoadDexUseCase(collection ?? MemoryCollection()),
  CheckBoosterAvailabilityUseCase(
    MemorySchedule(openedToday ? '2026-10-05' : null),
    now: () => fixedNow,
  ),
);

class ScriptedOpenBooster implements OpenBoosterUseCase {
  ScriptedOpenBooster(this.script);

  final Future<List<DrawnCard>> Function(int attempt) script;
  int attempts = 0;

  @override
  Future<List<DrawnCard>> call() => script(attempts++);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

BoosterCubit boosterCubitOf(ScriptedOpenBooster openBooster) =>
    BoosterCubit(openBooster);

final List<DrawnCard> mixedBooster = [
  drawnOf(1),
  drawnOf(2, rarity: CardRarity.rare, isNew: false),
  drawnOf(3, rarity: CardRarity.epic),
  drawnOf(4, rarity: CardRarity.legendary),
  drawnOf(5, isNew: false),
];
