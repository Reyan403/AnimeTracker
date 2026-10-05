import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/check_booster_availability_use_case.dart';
import '../../domain/use_cases/load_dex_use_case.dart';
import 'dex_state.dart';

class DexCubit extends Cubit<DexState> {
  DexCubit(this._loadDex, this._checkAvailability) : super(const DexState());

  final LoadDexUseCase _loadDex;
  final CheckBoosterAvailabilityUseCase _checkAvailability;

  void load() {
    try {
      final cards = _loadDex();
      final availability = _checkAvailability();

      emit(
        DexState(
          status: cards.isEmpty ? DexStatus.empty : DexStatus.success,
          cards: cards,
          availability: availability,
        ),
      );
    } on Object {
      emit(const DexState(status: DexStatus.failure));
    }
  }
}
