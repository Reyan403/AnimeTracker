import 'package:equatable/equatable.dart';

import '../../domain/entities/recommendation_set.dart';

enum RecommendationsStatus { loading, success, empty, failure }

class RecommendationsState extends Equatable {
  const RecommendationsState({
    this.status = RecommendationsStatus.loading,
    this.recommendations = RecommendationSet.none,
  });

  final RecommendationsStatus status;
  final RecommendationSet recommendations;

  @override
  List<Object?> get props => [status, recommendations];
}
