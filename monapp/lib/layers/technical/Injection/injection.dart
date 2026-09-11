import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../functional/Anime/data/gateways/anime_details_gateway_impl.dart';
import '../../functional/Anime/data/gateways/in_memory_watchlist_gateway.dart';
import '../../functional/Anime/data/my_watchlist.dart';
import '../../functional/Anime/domain/gateways/anime_details_gateway.dart';
import '../../functional/Anime/domain/gateways/watchlist_gateway.dart';
import '../../functional/Anime/domain/use_cases/add_to_watchlist_use_case.dart';
import '../../functional/Anime/domain/use_cases/change_watch_status_use_case.dart';
import '../../functional/Anime/domain/use_cases/listed_anime_ids_use_case.dart';
import '../../functional/Anime/domain/use_cases/load_watchlist_use_case.dart';
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
import '../TmdbApi/tmdb_client.dart';

const String tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');

final GetIt getIt = GetIt.instance;

void initializeDependencies() {
  if (getIt.isRegistered<LoadWatchlistUseCase>()) {
    return;
  }

  getIt
    ..registerLazySingleton<http.Client>(http.Client.new)
    ..registerLazySingleton<KitsuClient>(() => KitsuClient(getIt()))
    ..registerLazySingleton<TmdbClient>(
      () => TmdbClient(getIt(), apiKey: tmdbApiKey),
    )
    ..registerLazySingleton<AnimeDetailsGateway>(
      () => AnimeDetailsGatewayImpl(getIt()),
    )
    ..registerLazySingleton<WatchlistGateway>(
      () => InMemoryWatchlistGateway(MyWatchlist.entries),
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
      ),
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
