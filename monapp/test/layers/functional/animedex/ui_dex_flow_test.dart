import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Animedex/domain/use_cases/check_booster_availability_use_case.dart';
import 'package:monapp/layers/functional/Animedex/domain/use_cases/load_dex_use_case.dart';
import 'package:monapp/layers/functional/Animedex/presentation/animedex_view.dart';
import 'package:monapp/layers/functional/Animedex/presentation/booster/sealed_pack.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/booster_cubit.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/dex_cubit.dart';
import 'package:monapp/layers/functional/Animedex/presentation/widgets/dex_card_tile.dart';
import 'package:monapp/layers/technical/Injection/injection.dart';

import '../../../support/pump_app.dart';
import 'ui_support.dart';

void main() {
  late MemoryCollection collection;
  late MemorySchedule schedule;

  setUp(() {
    collection = MemoryCollection();
    schedule = MemorySchedule();
    getIt
      ..registerFactory<DexCubit>(
        () => DexCubit(
          LoadDexUseCase(collection),
          CheckBoosterAvailabilityUseCase(schedule, now: () => fixedNow),
        ),
      )
      ..registerFactory<BoosterCubit>(
        () => boosterCubitOf(
          ScriptedOpenBooster((_) async {
            final drawn = [drawnOf(7), drawnOf(8)];
            await collection.addAll([for (final entry in drawn) entry.card]);
            await schedule.markOpened('2026-10-05');

            return drawn;
          }),
        ),
      );
  });

  tearDown(getIt.reset);

  testWidgets('ouvrir le booster depuis l\'Animédex puis revenir', (
    tester,
  ) async {
    await pumpApp(tester, const AnimedexView(), settle: false);
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Ton Animédex est vide'), findsOneWidget);

    await tester.tap(find.text('Ouvrir mon premier booster'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(SealedPack), findsOneWidget);

    await tester.tap(find.byType(SealedPack));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('0 / 2'), findsOneWidget);

    await tester.tap(find.byTooltip('Fermer'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(DexCardTile), findsNWidgets(2));
    expect(find.text('2 cartes'), findsOneWidget);
    expect(find.text('Prochain booster dans'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
