import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/open_booster_use_case.dart';
import 'booster_state.dart';

class BoosterCubit extends Cubit<BoosterState> {
  BoosterCubit(this._openBooster) : super(const BoosterState());

  final OpenBoosterUseCase _openBooster;

  Future<void> open() async {
    if (state.status == BoosterStatus.opening) {
      return;
    }

    emit(const BoosterState(status: BoosterStatus.opening));

    try {
      final cards = await _openBooster();

      if (isClosed) {
        return;
      }

      emit(BoosterState(status: BoosterStatus.revealed, cards: cards));
    } on BoosterAlreadyOpenedException {
      _emitUnlessClosed(
        const BoosterState(status: BoosterStatus.alreadyOpened),
      );
    } on Object {
      _emitUnlessClosed(const BoosterState(status: BoosterStatus.failure));
    }
  }

  void reveal() {
    if (state.status != BoosterStatus.revealed || state.isComplete) {
      return;
    }

    emit(state.copyWith(revealedCount: state.revealedCount + 1));
  }

  void reset() => emit(const BoosterState());

  void _emitUnlessClosed(BoosterState next) {
    if (!isClosed) {
      emit(next);
    }
  }
}
