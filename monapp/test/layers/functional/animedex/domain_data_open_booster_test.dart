import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Animedex/domain/gateways/booster_candidate_gateway.dart';
import 'package:monapp/layers/functional/Animedex/domain/use_cases/open_booster_use_case.dart';

import '../../../support/animedex_fakes.dart';

final DateTime today = DateTime(2026, 10, 5, 14, 30);

OpenBoosterUseCase openerFor(
  FakeBoosterCandidateGateway candidates,
  FakeDexCollectionGateway collection,
  FakeBoosterScheduleGateway schedule,
) => OpenBoosterUseCase(
  candidates,
  collection,
  schedule,
  now: () => today,
  random: Random(1),
);

void main() {
  group('OpenBoosterUseCase', () {
    test('tire cinq cartes, ajoute les nouvelles et marque le jour', () async {
      final collection = FakeDexCollectionGateway([buildDexCard(2)]);
      final schedule = FakeBoosterScheduleGateway();
      final candidates = FakeBoosterCandidateGateway([
        [for (var id = 1; id <= 5; id++) buildDexCard(id)],
      ]);

      final drawn = await openerFor(candidates, collection, schedule)();

      expect(drawn, hasLength(5));
      expect(drawn.map((entry) => entry.card.characterId).toSet(), {
        1,
        2,
        3,
        4,
        5,
      });
      expect(drawn.where((entry) => !entry.isNew).single.card.characterId, 2);
      expect(collection.cards.map((card) => card.characterId).toSet(), {
        1,
        2,
        3,
        4,
        5,
      });
      expect(collection.cards, hasLength(5));
      expect(schedule.lastOpenedDay, '2026-10-05');
      expect(candidates.requestedCounts, [5]);
    });

    test('re-tire pour remplacer les doublons du booster', () async {
      final candidates = FakeBoosterCandidateGateway([
        [buildDexCard(1), buildDexCard(1), buildDexCard(2)],
        [buildDexCard(2), buildDexCard(3)],
        [buildDexCard(4), buildDexCard(5), buildDexCard(6)],
      ]);

      final drawn = await openerFor(
        candidates,
        FakeDexCollectionGateway(),
        FakeBoosterScheduleGateway(),
      )();

      expect(drawn.map((entry) => entry.card.characterId).toSet(), {
        1,
        2,
        3,
        4,
        5,
      });
      expect(candidates.requestedCounts, [5, 3, 2]);
      expect(candidates.receivedExclusions[1], {1, 2});
      expect(candidates.receivedExclusions[2], {1, 2, 3});
    });

    test('se contente de ce qu il obtient après quelques tentatives', () async {
      final candidates = FakeBoosterCandidateGateway([
        [buildDexCard(1)],
        [buildDexCard(1)],
        [buildDexCard(1)],
        [buildDexCard(1)],
      ]);
      final schedule = FakeBoosterScheduleGateway();

      final drawn = await openerFor(
        candidates,
        FakeDexCollectionGateway(),
        schedule,
      )();

      expect(drawn, hasLength(1));
      expect(candidates.calls, OpenBoosterUseCase.maxAttempts);
      expect(schedule.lastOpenedDay, '2026-10-05');
    });

    test('garde les cartes déjà tirées si un nouveau tirage échoue', () async {
      final schedule = FakeBoosterScheduleGateway();

      final drawn = await openerFor(
        FakeBoosterCandidateGateway([
          [buildDexCard(1), buildDexCard(2)],
        ]),
        FakeDexCollectionGateway(),
        schedule,
      )();

      expect(drawn, hasLength(2));
      expect(schedule.lastOpenedDay, '2026-10-05');
    });

    test('n ajoute aucune carte quand tout est déjà connu', () async {
      final collection = FakeDexCollectionGateway([
        for (var id = 1; id <= 5; id++) buildDexCard(id),
      ]);
      final candidates = FakeBoosterCandidateGateway([
        [for (var id = 1; id <= 5; id++) buildDexCard(id)],
      ]);

      final drawn = await openerFor(
        candidates,
        collection,
        FakeBoosterScheduleGateway(),
      )();

      expect(drawn.every((entry) => !entry.isNew), isTrue);
      expect(collection.cards, hasLength(5));
    });

    test('refuse un second booster le même jour', () async {
      final candidates = FakeBoosterCandidateGateway([
        [buildDexCard(1)],
      ]);

      expect(
        openerFor(
          candidates,
          FakeDexCollectionGateway(),
          FakeBoosterScheduleGateway('2026-10-05'),
        )(),
        throwsA(isA<BoosterAlreadyOpenedException>()),
      );
      expect(candidates.calls, 0);
    });

    test('laisse passer l indisponibilité sans marquer le jour', () async {
      final collection = FakeDexCollectionGateway();
      final schedule = FakeBoosterScheduleGateway();

      await expectLater(
        openerFor(
          FakeBoosterCandidateGateway.unavailable(),
          collection,
          schedule,
        )(),
        throwsA(isA<BoosterUnavailableException>()),
      );

      expect(schedule.lastOpenedDay, isNull);
      expect(collection.cards, isEmpty);
    });

    test('signale l indisponibilité quand aucune carte n est tirée', () async {
      final schedule = FakeBoosterScheduleGateway();

      await expectLater(
        openerFor(
          FakeBoosterCandidateGateway([[], [], [], []]),
          FakeDexCollectionGateway(),
          schedule,
        )(),
        throwsA(isA<BoosterUnavailableException>()),
      );

      expect(schedule.lastOpenedDay, isNull);
    });

    test('décrit les exceptions de manière lisible', () {
      expect(
        const BoosterAlreadyOpenedException().toString(),
        contains('already opened'),
      );
      expect(
        const BoosterUnavailableException().toString(),
        contains('unavailable'),
      );
    });

    test('fonctionne avec l horloge et le hasard par défaut', () async {
      final drawn = await OpenBoosterUseCase(
        FakeBoosterCandidateGateway([
          [buildDexCard(1)],
        ]),
        FakeDexCollectionGateway(),
        FakeBoosterScheduleGateway(),
      )();

      expect(drawn.single.isNew, isTrue);
    });
  });
}
