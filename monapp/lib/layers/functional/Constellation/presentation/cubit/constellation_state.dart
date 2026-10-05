import 'package:equatable/equatable.dart';

import '../../domain/entities/constellation.dart';
import '../../domain/entities/constellation_star.dart';

enum ConstellationStatus { loading, success, empty, failure }

class ConstellationState extends Equatable {
  const ConstellationState({
    this.status = ConstellationStatus.loading,
    this.constellation,
    this.selectedStarId,
    this.genreSlug,
  });

  final ConstellationStatus status;
  final Constellation? constellation;
  final int? selectedStarId;
  final String? genreSlug;

  ConstellationStar? get selectedStar {
    final id = selectedStarId;

    return constellation?.stars.where((star) => star.animeId == id).firstOrNull;
  }

  int linkCountOf(int animeId) =>
      constellation?.links
          .where((link) => link.fromId == animeId || link.toId == animeId)
          .length ??
      0;

  @override
  List<Object?> get props => [status, constellation, selectedStarId, genreSlug];
}
