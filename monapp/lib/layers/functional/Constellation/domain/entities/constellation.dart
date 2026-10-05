import 'package:equatable/equatable.dart';

import '../../../Discover/domain/entities/evening_mood.dart';
import 'constellation_link.dart';
import 'constellation_star.dart';

class Constellation extends Equatable {
  const Constellation({
    required this.stars,
    required this.links,
    required this.genres,
  });

  final List<ConstellationStar> stars;
  final List<ConstellationLink> links;
  final List<EveningMood> genres;

  @override
  List<Object?> get props => [stars, links, genres];
}
