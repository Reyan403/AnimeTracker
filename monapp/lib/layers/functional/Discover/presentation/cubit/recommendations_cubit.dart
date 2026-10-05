import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Anime/domain/use_cases/add_to_watchlist_use_case.dart';
import '../../../Catalogue/domain/entities/catalogue_anime.dart';
import '../../domain/entities/recommendation_set.dart';
import '../../domain/gateways/recommendation_gateway.dart';
import '../../domain/use_cases/recommend_anime_use_case.dart';
import 'recommendations_state.dart';

class RecommendationsCubit extends Cubit<RecommendationsState> {
  RecommendationsCubit(this._recommend, this._addToWatchlist)
      : super(const RecommendationsState());

  final RecommendAnimeUseCase _recommend;
  final AddToWatchlistUseCase _addToWatchlist;

  Future<void> load() async {
    emit(const RecommendationsState());

    try {
      final recommendations = await _recommend();

      if (isClosed) {
        return;
      }

      emit(
        RecommendationsState(
          status: recommendations.isEmpty
              ? RecommendationsStatus.empty
              : RecommendationsStatus.success,
          recommendations: recommendations,
        ),
      );
    } on RecommendationsUnavailableException {
      if (!isClosed) {
        emit(
          const RecommendationsState(status: RecommendationsStatus.failure),
        );
      }
    }
  }

  void add(CatalogueAnime anime) {
    _addToWatchlist(anime.id, anime.title);

    final remaining = [
      for (final candidate in state.recommendations.animes)
        if (candidate.id != anime.id) candidate,
    ];

    emit(
      RecommendationsState(
        status: remaining.isEmpty
            ? RecommendationsStatus.empty
            : RecommendationsStatus.success,
        recommendations: RecommendationSet(
          basedOn: state.recommendations.basedOn,
          animes: remaining,
        ),
      ),
    );
  }
}
