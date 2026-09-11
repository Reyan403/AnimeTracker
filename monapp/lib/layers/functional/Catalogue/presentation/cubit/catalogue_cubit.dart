import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Anime/domain/use_cases/add_to_watchlist_use_case.dart';
import '../../../Anime/domain/use_cases/listed_anime_ids_use_case.dart';
import '../../domain/entities/catalogue_anime.dart';
import '../../domain/entities/catalogue_page.dart';
import '../../domain/use_cases/browse_catalogue_use_case.dart';
import 'catalogue_state.dart';

class CatalogueCubit extends Cubit<CatalogueState> {
  CatalogueCubit(
    this._browseCatalogue,
    this._addToWatchlist,
    this._listedAnimeIds,
  ) : super(const CatalogueState()) {
    _listed = _listedAnimeIds().listen(_showListed);
  }

  static const Duration typingPause = Duration(milliseconds: 400);

  final BrowseCatalogueUseCase _browseCatalogue;
  final AddToWatchlistUseCase _addToWatchlist;
  final ListedAnimeIdsUseCase _listedAnimeIds;

  StreamSubscription<Set<int>>? _listed;
  Timer? _pendingSearch;
  int _lastRequest = 0;

  Future<void> load() => _browse(state.query);

  void addToWatchlist(CatalogueAnime anime) =>
      _addToWatchlist(anime.id, anime.title);

  void search(String query) {
    _pendingSearch?.cancel();
    emit(state.copyWith(query: query, status: _statusWhileTyping));
    _pendingSearch = Timer(typingPause, () => _browse(query));
  }

  CatalogueStatus get _statusWhileTyping => state.animes.isEmpty
      ? CatalogueStatus.loading
      : CatalogueStatus.success;

  Future<void> clear() {
    _pendingSearch?.cancel();
    emit(state.copyWith(query: '', status: CatalogueStatus.loading));

    return _browse('');
  }

  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.isAppending ||
        state.status != CatalogueStatus.success) {
      return;
    }

    final request = _lastRequest;
    final nextPage = state.page + 1;
    emit(state.copyWith(isAppending: true));

    try {
      final page = await _browseCatalogue(state.query, page: nextPage);

      _emitWhenCurrent(
        request,
        state.copyWith(
          animes: _withoutAlreadyShown(page.animes),
          page: nextPage,
          hasMore: page.hasMore,
          isAppending: false,
        ),
      );
    } catch (_) {
      _emitWhenCurrent(
        request,
        state.copyWith(hasMore: false, isAppending: false),
      );
    }
  }

  @override
  Future<void> close() async {
    _pendingSearch?.cancel();
    await _listed?.cancel();

    return super.close();
  }

  void _showListed(Set<int> listedIds) {
    if (isClosed) {
      return;
    }

    emit(state.copyWith(listedIds: listedIds));
  }

  Future<void> _browse(String query) async {
    final request = ++_lastRequest;

    try {
      _emitWhenCurrent(request, _browsed(await _browseCatalogue(query)));
    } catch (_) {
      _emitWhenCurrent(
        request,
        state.copyWith(
          animes: const [],
          status: CatalogueStatus.failure,
          hasMore: false,
          isAppending: false,
        ),
      );
    }
  }

  List<CatalogueAnime> _withoutAlreadyShown(List<CatalogueAnime> animes) {
    final shown = state.animes.map((anime) => anime.id).toSet();

    return [...state.animes, ...animes.where((anime) => shown.add(anime.id))];
  }

  CatalogueState _browsed(CataloguePage page) => state.copyWith(
        animes: page.animes,
        status:
            page.animes.isEmpty ? CatalogueStatus.empty : CatalogueStatus.success,
        page: BrowseCatalogueUseCase.firstPage,
        hasMore: page.hasMore,
        isAppending: false,
      );

  void _emitWhenCurrent(int request, CatalogueState next) {
    if (request != _lastRequest || isClosed) {
      return;
    }

    emit(next);
  }
}
