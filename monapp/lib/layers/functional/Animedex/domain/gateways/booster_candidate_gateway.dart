import '../entities/dex_card.dart';

abstract interface class BoosterCandidateGateway {
  Future<List<DexCard>> drawCandidates(
    int count, {
    required DateTime obtainedOn,
    Set<int> excludedIds,
  });
}

class BoosterUnavailableException implements Exception {
  const BoosterUnavailableException();

  @override
  String toString() => 'The booster candidates are unavailable';
}
