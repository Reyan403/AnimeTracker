import 'dart:math';

import '../entities/dex_card.dart';
import '../entities/drawn_card.dart';
import '../gateways/booster_candidate_gateway.dart';
import '../gateways/booster_schedule_gateway.dart';
import '../gateways/dex_collection_gateway.dart';
import 'booster_day.dart';

class BoosterAlreadyOpenedException implements Exception {
  const BoosterAlreadyOpenedException();

  @override
  String toString() => 'The booster of the day was already opened';
}

class OpenBoosterUseCase {
  OpenBoosterUseCase(
    this._candidates,
    this._collection,
    this._schedule, {
    DateTime Function()? now,
    Random? random,
  }) : _now = now ?? DateTime.now,
       _random = random ?? Random();

  static const int boosterSize = 5;
  static const int maxAttempts = 4;

  final BoosterCandidateGateway _candidates;
  final DexCollectionGateway _collection;
  final BoosterScheduleGateway _schedule;
  final DateTime Function() _now;
  final Random _random;

  Future<List<DrawnCard>> call() async {
    final moment = _now();
    final day = BoosterDay.keyOf(moment);

    if (_schedule.lastOpenedDay == day) {
      throw const BoosterAlreadyOpenedException();
    }

    final drawn = await _drawDistinct(moment);
    drawn.shuffle(_random);
    final owned = {for (final card in _collection.cards) card.characterId};
    final result = [
      for (final card in drawn)
        DrawnCard(card: card, isNew: !owned.contains(card.characterId)),
    ];

    await _collection.addAll([
      for (final entry in result)
        if (entry.isNew) entry.card,
    ]);
    await _schedule.markOpened(day);

    return result;
  }

  Future<List<DexCard>> _drawDistinct(DateTime moment) async {
    final chosen = <int, DexCard>{};

    for (
      var attempt = 0;
      attempt < maxAttempts && chosen.length < boosterSize;
      attempt++
    ) {
      final batch = await _fetch(
        boosterSize - chosen.length,
        moment,
        chosen.keys.toSet(),
      );

      if (batch == null) {
        break;
      }

      for (final card in batch) {
        if (chosen.length < boosterSize) {
          chosen.putIfAbsent(card.characterId, () => card);
        }
      }
    }

    if (chosen.isEmpty) {
      throw const BoosterUnavailableException();
    }

    return chosen.values.toList();
  }

  Future<List<DexCard>?> _fetch(
    int count,
    DateTime moment,
    Set<int> excludedIds,
  ) async {
    try {
      return await _candidates.drawCandidates(
        count,
        obtainedOn: moment,
        excludedIds: excludedIds,
      );
    } on BoosterUnavailableException {
      return null;
    }
  }
}
