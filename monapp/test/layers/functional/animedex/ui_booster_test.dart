import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/drawn_card.dart';
import 'package:monapp/layers/functional/Animedex/domain/gateways/booster_candidate_gateway.dart';
import 'package:monapp/layers/functional/Animedex/domain/use_cases/open_booster_use_case.dart';
import 'package:monapp/layers/functional/Animedex/presentation/booster/booster_page.dart';
import 'package:monapp/layers/functional/Animedex/presentation/booster/drawn_badge.dart';
import 'package:monapp/layers/functional/Animedex/presentation/booster/rarity_burst.dart';
import 'package:monapp/layers/functional/Animedex/presentation/booster/reveal_card.dart';
import 'package:monapp/layers/functional/Animedex/presentation/booster/sealed_pack.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/booster_cubit.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/booster_state.dart';

import '../../../support/pump_app.dart';
import 'ui_support.dart';

Future<void> pumpBooster(WidgetTester tester, BoosterCubit cubit) async {
  await pumpApp(
    tester,
    BlocProvider.value(
      value: cubit,
      child: BoosterScaffold(now: () => fixedNow),
    ),
    settle: false,
  );
}

Future<void> settleFor(WidgetTester tester, [int milliseconds = 2000]) async {
  await tester.pump();
  await tester.pump(Duration(milliseconds: milliseconds));
}

Future<void> teardown(WidgetTester tester) =>
    tester.pumpWidget(const SizedBox());

Future<void> tapCard(WidgetTester tester) async {
  await tester.tap(find.byType(RevealCard));
  await settleFor(tester);
}

void main() {
  group('BoosterCubit', () {
    test('tirage réussi : cartes tirées, aucune révélée', () async {
      final cubit = boosterCubitOf(
        ScriptedOpenBooster((_) async => mixedBooster),
      );

      await cubit.open();

      expect(cubit.state.status, BoosterStatus.revealed);
      expect(cubit.state.cards, mixedBooster);
      expect(cubit.state.revealedCount, 0);
      expect(cubit.state.newCount, 3);
      expect(cubit.state.duplicateCount, 2);
    });

    test('passe par l\'état opening pendant le tirage', () async {
      final completer = Completer<List<DrawnCard>>();
      final cubit = boosterCubitOf(
        ScriptedOpenBooster((_) => completer.future),
      );
      final states = <BoosterStatus>[];
      cubit.stream.listen((state) => states.add(state.status));

      final opening = cubit.open();
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.status, BoosterStatus.opening);

      completer.complete(mixedBooster);
      await opening;
      await Future<void>.delayed(Duration.zero);

      expect(states, [BoosterStatus.opening, BoosterStatus.revealed]);
    });

    test('ignore une seconde ouverture pendant le tirage', () async {
      final completer = Completer<List<DrawnCard>>();
      final script = ScriptedOpenBooster((_) => completer.future);
      final cubit = boosterCubitOf(script);

      final first = cubit.open();
      await cubit.open();
      completer.complete(mixedBooster);
      await first;

      expect(script.attempts, 1);
    });

    test('révèle les cartes une à une puis s\'arrête', () async {
      final cubit = boosterCubitOf(
        ScriptedOpenBooster((_) async => mixedBooster),
      );
      await cubit.open();

      for (var index = 1; index <= 5; index++) {
        cubit.reveal();
        expect(cubit.state.revealedCount, index);
      }
      cubit.reveal();

      expect(cubit.state.revealedCount, 5);
      expect(cubit.state.isComplete, isTrue);
      expect(cubit.state.current, mixedBooster.last);
    });

    test('révéler avant le tirage ne fait rien', () {
      final cubit = boosterCubitOf(
        ScriptedOpenBooster((_) async => mixedBooster),
      )..reveal();

      expect(cubit.state.revealedCount, 0);
      expect(cubit.state.current, isNull);
    });

    test('booster déjà ouvert', () async {
      final cubit = boosterCubitOf(
        ScriptedOpenBooster(
          (_) async => throw const BoosterAlreadyOpenedException(),
        ),
      );

      await cubit.open();

      expect(cubit.state.status, BoosterStatus.alreadyOpened);
    });

    test('erreur réseau puis nouvel essai', () async {
      final cubit = boosterCubitOf(
        ScriptedOpenBooster((attempt) async {
          if (attempt == 0) {
            throw const BoosterUnavailableException();
          }

          return mixedBooster;
        }),
      );

      await cubit.open();
      expect(cubit.state.status, BoosterStatus.failure);

      await cubit.open();
      expect(cubit.state.status, BoosterStatus.revealed);
    });

    test('reset revient à l\'état initial', () async {
      final cubit = boosterCubitOf(
        ScriptedOpenBooster(
          (_) async => throw const BoosterAlreadyOpenedException(),
        ),
      );
      await cubit.open();

      cubit.reset();

      expect(cubit.state, const BoosterState());
    });

    test('rien n\'est émis après fermeture', () async {
      final completer = Completer<List<DrawnCard>>();
      final cubit = boosterCubitOf(
        ScriptedOpenBooster((_) => completer.future),
      );

      final opening = cubit.open();
      await cubit.close();
      completer.complete(mixedBooster);
      await opening;

      expect(cubit.isClosed, isTrue);
    });
  });

  group('BoosterScaffold', () {
    testWidgets('paquet scellé : toucher lance le tirage', (tester) async {
      final completer = Completer<List<DrawnCard>>();
      final cubit = boosterCubitOf(
        ScriptedOpenBooster((_) => completer.future),
      );
      await pumpBooster(tester, cubit);

      expect(find.byType(SealedPack), findsOneWidget);
      expect(find.text('Touche le paquet pour l\'ouvrir'), findsOneWidget);

      await tester.tap(find.byType(SealedPack));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Ouverture en cours…'), findsOneWidget);
      expect(find.byType(SealedPack), findsOneWidget);

      completer.complete(mixedBooster);
      await settleFor(tester);

      expect(find.byType(SealedPack), findsNothing);
      expect(find.text('0 / 5'), findsOneWidget);
      await teardown(tester);
    });

    testWidgets('révélation carte par carte avec badges et récap', (
      tester,
    ) async {
      final cubit = boosterCubitOf(
        ScriptedOpenBooster((_) async => mixedBooster),
      );
      await pumpBooster(tester, cubit);
      await tester.tap(find.byType(SealedPack));
      await settleFor(tester);

      expect(find.text('Touche la carte pour la révéler'), findsOneWidget);
      expect(find.byType(DrawnBadge), findsNothing);

      await tapCard(tester);
      expect(find.text('1 / 5'), findsOneWidget);
      expect(find.text('Anime 1'), findsOneWidget);
      expect(find.text('NOUVEAU'), findsOneWidget);

      await tapCard(tester);
      expect(find.text('2 / 5'), findsOneWidget);
      expect(find.text('Doublon'), findsOneWidget);
      expect(find.text('NOUVEAU'), findsNothing);
      expect(find.byType(RarityBurst), findsOneWidget);

      await tapCard(tester);
      await tapCard(tester);
      expect(find.text('4 / 5'), findsOneWidget);
      expect(find.text('Légendaire'), findsOneWidget);
      expect(find.text('Voir mon Animédex'), findsNothing);

      await tapCard(tester);
      expect(find.text('5 / 5'), findsOneWidget);
      expect(find.text('Récap du booster'), findsOneWidget);
      expect(find.text('3 nouvelles cartes · 2 doublons'), findsOneWidget);
      expect(find.text('Voir mon Animédex'), findsOneWidget);
      await teardown(tester);
    });

    testWidgets('réduction des animations : révélation instantanée', (
      tester,
    ) async {
      final cubit = boosterCubitOf(
        ScriptedOpenBooster((_) async => mixedBooster),
      );
      await pumpApp(
        tester,
        BlocProvider.value(
          value: cubit,
          child: BoosterScaffold(now: () => fixedNow),
        ),
        disableAnimations: true,
      );
      await tester.tap(find.byType(SealedPack));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RevealCard));
      await tester.pumpAndSettle();

      expect(find.text('Anime 1'), findsOneWidget);
      expect(find.text('NOUVEAU'), findsOneWidget);
    });

    testWidgets('déjà ouvert : message et compte à rebours', (tester) async {
      final cubit = boosterCubitOf(
        ScriptedOpenBooster(
          (_) async => throw const BoosterAlreadyOpenedException(),
        ),
      );
      await pumpBooster(tester, cubit);
      await tester.tap(find.byType(SealedPack));
      await settleFor(tester);

      expect(find.text('Booster déjà ouvert aujourd\'hui'), findsOneWidget);
      expect(find.text('03:29:45'), findsOneWidget);
      expect(find.text('Voir mon Animédex'), findsOneWidget);
      await teardown(tester);
    });

    testWidgets('erreur réseau : réessayer sans consommer le booster', (
      tester,
    ) async {
      final script = ScriptedOpenBooster((attempt) async {
        if (attempt == 0) {
          throw const BoosterUnavailableException();
        }

        return mixedBooster;
      });
      final cubit = boosterCubitOf(script);
      await pumpBooster(tester, cubit);
      await tester.tap(find.byType(SealedPack));
      await settleFor(tester);

      expect(find.text('Le booster n\'a pas pu être tiré'), findsOneWidget);
      expect(find.textContaining('Unavailable'), findsNothing);

      await tester.tap(find.text('Réessayer'));
      await settleFor(tester);

      expect(script.attempts, 2);
      expect(find.text('0 / 5'), findsOneWidget);
      await teardown(tester);
    });

    testWidgets('« Voir mon Animédex » referme la page', (tester) async {
      final cubit = boosterCubitOf(
        ScriptedOpenBooster((_) async => [drawnOf(1)]),
      );

      await pumpApp(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: BoosterScaffold(now: () => fixedNow),
                ),
              ),
            ),
            child: const Text('Aller'),
          ),
        ),
      );
      await tester.tap(find.text('Aller'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(find.byType(SealedPack));
      await settleFor(tester);
      await tapCard(tester);

      await tester.tap(find.text('Voir mon Animédex'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Aller'), findsOneWidget);
      await teardown(tester);
    });

    testWidgets('la croix referme la page', (tester) async {
      final cubit = boosterCubitOf(
        ScriptedOpenBooster((_) async => mixedBooster),
      );

      await pumpApp(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: BoosterScaffold(now: () => fixedNow),
                ),
              ),
            ),
            child: const Text('Aller'),
          ),
        ),
      );
      await tester.tap(find.text('Aller'));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(find.byTooltip('Fermer'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Aller'), findsOneWidget);
      await teardown(tester);
    });
  });
}
