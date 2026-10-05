import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/card_rarity.dart';
import '../../domain/use_cases/check_booster_availability_use_case.dart';
import '../../domain/use_cases/load_dex_use_case.dart';
import 'dex_filter.dart';
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
        state.copyWith(
          status: cards.isEmpty ? DexStatus.empty : DexStatus.success,
          cards: cards,
          availability: availability,
        ),
      );
    } on Object {
      emit(state.copyWith(status: DexStatus.failure));
    }
  }

  void selectTab(DexTab tab) => emit(state.copyWith(tab: tab));

  void search(String query) =>
      emit(state.copyWith(filter: state.filter.withQuery(query)));

  void selectRarity(CardRarity? rarity) =>
      emit(state.copyWith(filter: state.filter.withRarity(rarity)));

  void selectSort(DexSort sort) =>
      emit(state.copyWith(filter: state.filter.withSort(sort)));

  void resetFilters() => emit(state.copyWith(filter: state.filter.cleared));
}
