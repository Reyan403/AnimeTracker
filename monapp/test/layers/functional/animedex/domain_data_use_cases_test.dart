import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/card_rarity.dart';
import 'package:monapp/layers/functional/Animedex/domain/use_cases/check_booster_availability_use_case.dart';
import 'package:monapp/layers/functional/Animedex/domain/use_cases/load_dex_use_case.dart';

import '../../../support/animedex_fakes.dart';

final DateTime today = DateTime(2026, 10, 5, 14, 30);
void main() {
  group('LoadDexUseCase', () {
    test('trie par rareté décroissante puis par date décroissante', () {
      final collection = FakeDexCollectionGateway([
        buildDexCard(1, obtainedOn: DateTime(2026, 10, 1)),
        buildDexCard(
          2,
          rarity: CardRarity.legendary,
          obtainedOn: DateTime(2026, 9, 1),
        ),
        buildDexCard(3, obtainedOn: DateTime(2026, 10, 3)),
        buildDexCard(
          4,
          rarity: CardRarity.epic,
          obtainedOn: DateTime(2026, 8, 1),
        ),
      ]);

      final ids = LoadDexUseCase(collection)().map((card) => card.characterId);

      expect(ids, [2, 4, 3, 1]);
    });

    test('renvoie une liste vide pour une collection vide', () {
      expect(LoadDexUseCase(FakeDexCollectionGateway())(), isEmpty);
    });
  });

  group('CheckBoosterAvailabilityUseCase', () {
    test('est disponible quand aucun booster n a été ouvert', () {
      final availability = CheckBoosterAvailabilityUseCase(
        FakeBoosterScheduleGateway(),
        now: () => today,
      )();

      expect(availability.isAvailable, isTrue);
      expect(availability.nextAt, DateTime(2026, 10, 6));
    });

    test('est indisponible quand le booster du jour est ouvert', () {
      final availability = CheckBoosterAvailabilityUseCase(
        FakeBoosterScheduleGateway('2026-10-05'),
        now: () => today,
      )();

      expect(availability.isAvailable, isFalse);
    });

    test('est disponible le lendemain', () {
      final availability = CheckBoosterAvailabilityUseCase(
        FakeBoosterScheduleGateway('2026-10-04'),
        now: () => today,
      )();

      expect(availability.isAvailable, isTrue);
    });

    test('calcule minuit en fin de mois et d année', () {
      final availability = CheckBoosterAvailabilityUseCase(
        FakeBoosterScheduleGateway(),
        now: () => DateTime(2026, 12, 31, 23, 59),
      )();

      expect(availability.nextAt, DateTime(2027, 1, 1));
    });

    test('utilise l horloge réelle par défaut', () {
      final availability = CheckBoosterAvailabilityUseCase(
        FakeBoosterScheduleGateway(),
      )();

      expect(availability.isAvailable, isTrue);
    });
  });
}
