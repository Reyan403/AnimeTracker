import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Anime/domain/use_cases/add_to_watchlist_use_case.dart';
import '../../domain/entities/evening_mood.dart';
import '../../domain/gateways/catalogue_suggestion_gateway.dart';
import '../../domain/use_cases/suggest_evening_watch_use_case.dart';
import 'evening_state.dart';

class EveningCubit extends Cubit<EveningState> {
  EveningCubit(this._suggest, this._addToWatchlist)
      : super(const EveningState());

  final SuggestEveningWatchUseCase _suggest;
  final AddToWatchlistUseCase _addToWatchlist;

  void selectMood(EveningMood mood) => emit(EveningState(mood: mood));

  Future<void> suggest() => _pick(excluded: const {});

  Future<void> suggestAnother() => _pick(excluded: state.shownIds);

  void addSuggestionToWatchlist() {
    final suggestion = state.suggestion;

    if (suggestion == null || suggestion.isListed) {
      return;
    }

    _addToWatchlist(suggestion.anime.id, suggestion.anime.title);
    emit(
      EveningState(
        status: EveningStatus.suggested,
        mood: state.mood,
        suggestion: suggestion.asListed(),
        shownIds: state.shownIds,
      ),
    );
  }

  Future<void> _pick({required Set<int> excluded}) async {
    emit(
      EveningState(
        status: EveningStatus.loading,
        mood: state.mood,
        shownIds: excluded,
      ),
    );

    try {
      final suggestion = await _suggest(
        mood: state.mood,
        excludedIds: excluded,
      );

      if (isClosed) {
        return;
      }

      emit(
        EveningState(
          status: suggestion == null
              ? EveningStatus.none
              : EveningStatus.suggested,
          mood: state.mood,
          suggestion: suggestion,
          shownIds: {...excluded, ?suggestion?.anime.id},
        ),
      );
    } on CatalogueSuggestionUnavailableException {
      if (!isClosed) {
        emit(EveningState(status: EveningStatus.failure, mood: state.mood));
      }
    }
  }
}
