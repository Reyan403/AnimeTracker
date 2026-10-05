import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/card_rarity.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/dex_card.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/drawn_card.dart';
import 'package:monapp/layers/functional/Animedex/domain/gateways/booster_schedule_gateway.dart';
import 'package:monapp/layers/functional/Animedex/domain/gateways/dex_collection_gateway.dart';
import 'package:monapp/layers/functional/Animedex/domain/use_cases/check_booster_availability_use_case.dart';
import 'package:monapp/layers/functional/Animedex/domain/use_cases/load_dex_use_case.dart';
import 'package:monapp/layers/functional/Animedex/domain/use_cases/open_booster_use_case.dart';
import 'package:monapp/layers/functional/Animedex/presentation/animedex_view.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/booster_cubit.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/dex_cubit.dart';
import 'package:monapp/layers/functional/Animedex/presentation/widgets/dex_card_tile.dart';

import '../../../support/animedex_fakes.dart';
import '../../../support/pump_app.dart';

final DateTime fixedNow = DateTime(2026, 10, 5, 20, 30, 15);

const Size tallScreen = Size(500, 1800);

DexCard cardOf(
  int id, {
  CardRarity rarity = CardRarity.common,
  String? name,
  int favourites = 1000,
  String? animeTitle,
  String? nativeName,
  DateTime? obtainedOn,
}) => buildDexCard(
  id,
  rarity: rarity,
  name: name,
  favourites: favourites,
  animeTitle: animeTitle,
  nativeName: nativeName,
  obtainedOn: obtainedOn ?? fixedNow,
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

Future<DexCubit> pumpDex(
  WidgetTester tester,
  DexCubit cubit, {
  bool load = true,
  Size size = const Size(400, 800),
}) async {
  if (load) {
    cubit.load();
  }

  await pumpApp(
    tester,
    BlocProvider.value(
      value: cubit,
      child: AnimedexScaffold(now: () => fixedNow),
    ),
    size: size,
    settle: false,
  );
  await tester.pump(const Duration(seconds: 1));

  return cubit;
}

List<String> tileNames(WidgetTester tester) => [
  for (final tile in tester.widgetList<DexCardTile>(find.byType(DexCardTile)))
    tile.card.name,
];

final List<DexCard> sampleCollection = [
  cardOf(
    1,
    name: 'Naruto Uzumaki',
    animeTitle: 'Naruto',
    nativeName: 'うずまきナルト',
    favourites: 5000,
    obtainedOn: DateTime(2026, 10, 3),
  ),
  cardOf(
    2,
    name: 'Élise Moreau',
    rarity: CardRarity.rare,
    animeTitle: 'Bleach',
    favourites: 40000,
    obtainedOn: DateTime(2026, 10, 4),
  ),
  cardOf(
    3,
    name: 'Light Yagami',
    rarity: CardRarity.epic,
    animeTitle: 'Death Note',
    favourites: 90000,
    obtainedOn: DateTime(2026, 10, 5),
  ),
  cardOf(
    4,
    name: 'Zoro',
    rarity: CardRarity.legendary,
    animeTitle: 'One Piece',
    favourites: 70000,
    obtainedOn: DateTime(2026, 10, 5),
  ),
  cardOf(
    5,
    name: 'Mikasa',
    animeTitle: 'Attack on Titan',
    favourites: 30000,
    obtainedOn: DateTime(2026, 10, 2),
  ),
];
