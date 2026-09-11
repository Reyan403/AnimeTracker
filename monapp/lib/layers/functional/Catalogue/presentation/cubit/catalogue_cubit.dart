import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/gateways/anime_catalogue_gateway.dart';
import '../../domain/use_cases/browse_catalogue_use_case.dart';
import 'catalogue_state.dart';

class CatalogueCubit extends Cubit<CatalogueState> {
  CatalogueCubit(this._browseCatalogue) : super(const CatalogueState());

  static const Duration typingPause = Duration(milliseconds: 400);

  final BrowseCatalogueUseCase _browseCatalogue;

  Timer? _pendingSearch;
  int _lastRequest = 0;

  Future<void> load() => _browse(state.query);

  void search(String query) {
    _pendingSearch?.cancel();
    emit(state.copyWith(query: query, status: CatalogueStatus.loading));
    _pendingSearch = Timer(typingPause, () => _browse(query));
  }

  Future<void> clear() {
    _pendingSearch?.cancel();
    emit(state.copyWith(query: '', status: CatalogueStatus.loading));

    return _browse('');
  }

  @override
  Future<void> close() {
    _pendingSearch?.cancel();

    return super.close();
  }

  Future<void> _browse(String query) async {
    final request = ++_lastRequest;

    try {
      final animes = await _browseCatalogue(query);

      _emitWhenCurrent(
        request,
        state.copyWith(
          animes: animes,
          status:
              animes.isEmpty ? CatalogueStatus.empty : CatalogueStatus.success,
        ),
      );
    } on CatalogueUnavailableException {
      _emitWhenCurrent(
        request,
        state.copyWith(animes: const [], status: CatalogueStatus.failure),
      );
    }
  }

  void _emitWhenCurrent(int request, CatalogueState next) {
    if (request != _lastRequest || isClosed) {
      return;
    }

    emit(next);
  }
}
