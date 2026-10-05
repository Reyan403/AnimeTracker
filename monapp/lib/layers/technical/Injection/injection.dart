import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../functional/Agenda/domain/use_cases/load_release_agenda_use_case.dart';
import '../../functional/Agenda/presentation/cubit/agenda_cubit.dart';
import '../../functional/Anime/data/gateways/anime_details_gateway_impl.dart';
import '../../functional/Anime/data/gateways/local_watchlist_gateway.dart';
import '../../functional/Anime/data/my_watchlist.dart';
import '../../functional/Anime/data/stores/preferences_watchlist_store.dart';
import '../../functional/Anime/data/stores/watchlist_store.dart';
import '../../functional/Anime/domain/gateways/anime_details_gateway.dart';
import '../../functional/Anime/domain/gateways/watchlist_gateway.dart';
import '../../functional/Anime/domain/use_cases/add_to_watchlist_use_case.dart';
import '../../functional/Anime/domain/use_cases/change_watch_status_use_case.dart';
import '../../functional/Anime/domain/use_cases/listed_anime_ids_use_case.dart';
import '../../functional/Anime/domain/use_cases/load_watchlist_use_case.dart';
import '../../functional/Anime/domain/use_cases/watch_next_episode_use_case.dart';
import '../../functional/Anime/domain/use_cases/watch_previous_episode_use_case.dart';
import '../../functional/Anime/presentation/cubit/watchlist_cubit.dart';
import '../../functional/Catalogue/data/gateways/anime_catalogue_gateway_impl.dart';
import '../../functional/Catalogue/data/gateways/anime_sheet_gateway_impl.dart';
import '../../functional/Catalogue/data/gateways/french_synopsis_gateway_impl.dart';
import '../../functional/Catalogue/domain/gateways/anime_catalogue_gateway.dart';
import '../../functional/Catalogue/domain/gateways/anime_sheet_gateway.dart';
import '../../functional/Catalogue/domain/gateways/french_synopsis_gateway.dart';
import '../../functional/Catalogue/domain/use_cases/browse_catalogue_use_case.dart';
import '../../functional/Catalogue/domain/use_cases/load_anime_sheet_use_case.dart';
import '../../functional/Catalogue/presentation/cubit/anime_sheet_cubit.dart';
import '../../functional/Catalogue/presentation/cubit/catalogue_cubit.dart';
import '../KitsuApi/kitsu_client.dart';
import '../Preferences/app_preferences.dart';
import '../TmdbApi/tmdb_client.dart';

const String tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  if (getIt.isRegistered<LoadWatchlistUseCase>()) {
    return;
  }

  final preferences = await AppPreferences.open();

  getIt
    ..registerSingleton<AppPreferences>(preferences)
    ..registerLazySingleton<http.Client>(http.Client.new)
    ..registerLazySingleton<KitsuClient>(() => KitsuClient(getIt()))
    ..registerLazySingleton<TmdbClient>(
      () => TmdbClient(getIt(), apiKey: tmdbApiKey),
    )
    ..registerLazySingleton<AnimeDetailsGateway>(
      () => AnimeDetailsGatewayImpl(getIt()),
    )
    ..registerLazySingleton<WatchlistStore>(
      () => PreferencesWatchlistStore(getIt()),
    )
    ..registerLazySingleton<WatchlistGateway>(
      () => LocalWatchlistGateway(getIt(), MyWatchlist.entries),
    )
    ..registerLazySingleton<AnimeSheetGateway>(
      () => AnimeSheetGatewayImpl(getIt()),
    )
    ..registerLazySingleton<FrenchSynopsisGateway>(
      () => FrenchSynopsisGatewayImpl(getIt()),
    )
    ..registerLazySingleton<AnimeCatalogueGateway>(
      () => AnimeCatalogueGatewayImpl(getIt()),
    )
    ..registerLazySingleton<LoadWatchlistUseCase>(
      () => LoadWatchlistUseCase(
        getIt<AnimeDetailsGateway>(),
        getIt<WatchlistGateway>(),
      ),
    )
    ..registerLazySingleton<AddToWatchlistUseCase>(
      () => AddToWatchlistUseCase(getIt<WatchlistGateway>()),
    )
    ..registerLazySingleton<ListedAnimeIdsUseCase>(
      () => ListedAnimeIdsUseCase(getIt<WatchlistGateway>()),
    )
    ..registerLazySingleton<ChangeWatchStatusUseCase>(
      () => ChangeWatchStatusUseCase(getIt<WatchlistGateway>()),
    )
    ..registerLazySingleton<WatchNextEpisodeUseCase>(
      () => WatchNextEpisodeUseCase(getIt<WatchlistGateway>()),
    )
    ..registerLazySingleton<WatchPreviousEpisodeUseCase>(
      () => WatchPreviousEpisodeUseCase(getIt<WatchlistGateway>()),
    )
    ..registerLazySingleton<LoadReleaseAgendaUseCase>(
      () => LoadReleaseAgendaUseCase(getIt<LoadWatchlistUseCase>()),
    )
    ..registerLazySingleton<LoadAnimeSheetUseCase>(
      () => LoadAnimeSheetUseCase(
        getIt<AnimeSheetGateway>(),
        getIt<FrenchSynopsisGateway>(),
      ),
    )
    ..registerLazySingleton<BrowseCatalogueUseCase>(
      () => BrowseCatalogueUseCase(getIt<AnimeCatalogueGateway>()),
    )
    ..registerFactory<WatchlistCubit>(
      () => WatchlistCubit(
        getIt<LoadWatchlistUseCase>(),
        getIt<ChangeWatchStatusUseCase>(),
        getIt<WatchNextEpisodeUseCase>(),
        getIt<WatchPreviousEpisodeUseCase>(),
      ),
    )
    ..registerFactory<AgendaCubit>(
      () => AgendaCubit(getIt<LoadReleaseAgendaUseCase>()),
    )
    ..registerFactory<AnimeSheetCubit>(
      () => AnimeSheetCubit(getIt<LoadAnimeSheetUseCase>()),
    )
    ..registerFactory<CatalogueCubit>(
      () => CatalogueCubit(
        getIt<BrowseCatalogueUseCase>(),
        getIt<AddToWatchlistUseCase>(),
        getIt<ListedAnimeIdsUseCase>(),
      ),
    );
}
