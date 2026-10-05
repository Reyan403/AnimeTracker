import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/constellation.dart';
import '../../domain/use_cases/build_constellation_use_case.dart';
import 'constellation_state.dart';

class ConstellationCubit extends Cubit<ConstellationState> {
  ConstellationCubit(this._buildConstellation)
    : super(const ConstellationState());

  final BuildConstellationUseCase _buildConstellation;

  StreamSubscription<Constellation>? _building;

  Future<void> load() async {
    unawaited(_building?.cancel());
    emit(const ConstellationState());

    _building = _buildConstellation().listen(
      _show,
      onError: (_) =>
          emit(const ConstellationState(status: ConstellationStatus.failure)),
    );
  }

  void select(int? animeId) {
    if (state.status != ConstellationStatus.success) {
      return;
    }

    emit(
      ConstellationState(
        status: state.status,
        constellation: state.constellation,
        selectedStarId: animeId,
        genreSlug: state.genreSlug,
      ),
    );
  }

  void filterByGenre(String? slug) {
    if (state.status != ConstellationStatus.success) {
      return;
    }

    emit(
      ConstellationState(
        status: state.status,
        constellation: state.constellation,
        selectedStarId: state.selectedStarId,
        genreSlug: slug,
      ),
    );
  }

  @override
  Future<void> close() async {
    unawaited(_building?.cancel());

    return super.close();
  }

  void _show(Constellation constellation) {
    if (isClosed) {
      return;
    }

    final previous = state.selectedStarId;
    final stillThere = constellation.stars.any(
      (star) => star.animeId == previous,
    );

    emit(
      ConstellationState(
        status: constellation.stars.isEmpty
            ? ConstellationStatus.empty
            : ConstellationStatus.success,
        constellation: constellation,
        selectedStarId: stillThere ? previous : null,
        genreSlug: state.genreSlug,
      ),
    );
  }
}
