import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/evening_duration.dart';
import '../../domain/entities/evening_mood.dart';
import '../../domain/use_cases/suggest_evening_watch_use_case.dart';
import 'evening_state.dart';

class EveningCubit extends Cubit<EveningState> {
  EveningCubit(this._suggest) : super(const EveningState());

  final SuggestEveningWatchUseCase _suggest;

  void selectMood(EveningMood mood) =>
      emit(EveningState(mood: mood, duration: state.duration));

  void selectDuration(EveningDuration duration) =>
      emit(EveningState(mood: state.mood, duration: duration));

  Future<void> suggest() => _pick(excluded: const {});

  Future<void> suggestAnother() => _pick(excluded: state.shownIds);

  Future<void> _pick({required Set<int> excluded}) async {
    emit(
      EveningState(
        status: EveningStatus.loading,
        mood: state.mood,
        duration: state.duration,
        shownIds: excluded,
      ),
    );

    try {
      final suggestion = await _suggest(
        mood: state.mood,
        duration: state.duration,
        excludedIds: excluded,
      );

      if (isClosed) {
        return;
      }

      if (suggestion == null && excluded.isNotEmpty) {
        await _pick(excluded: const {});

        return;
      }

      emit(
        EveningState(
          status: suggestion == null
              ? EveningStatus.none
              : EveningStatus.suggested,
          mood: state.mood,
          duration: state.duration,
          suggestion: suggestion,
          shownIds: {...excluded, ?suggestion?.anime.id},
        ),
      );
    } on EveningSuggestionUnavailableException {
      if (!isClosed) {
        emit(
          EveningState(
            status: EveningStatus.failure,
            mood: state.mood,
            duration: state.duration,
          ),
        );
      }
    }
  }
}
