import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../functional/Anime/data/gateways/anime_details_gateway_impl.dart';
import '../../functional/Anime/data/my_watchlist.dart';
import '../../functional/Anime/domain/gateways/anime_details_gateway.dart';
import '../../functional/Anime/domain/use_cases/load_watchlist_use_case.dart';
import '../../functional/Anime/presentation/cubit/watchlist_cubit.dart';
import '../../functional/Catalogue/data/gateways/anime_catalogue_gateway_impl.dart';
import '../../functional/Catalogue/domain/gateways/anime_catalogue_gateway.dart';
import '../../functional/Catalogue/domain/use_cases/browse_catalogue_use_case.dart';
import '../../functional/Catalogue/presentation/cubit/catalogue_cubit.dart';
import '../JikanApi/jikan_client.dart';
import '../KitsuApi/kitsu_client.dart';

final GetIt getIt = GetIt.instance;

void initializeDependencies() {
  if (getIt.isRegistered<LoadWatchlistUseCase>()) {
    return;
  }

  getIt
    ..registerLazySingleton<http.Client>(http.Client.new)
    ..registerLazySingleton<JikanClient>(() => JikanClient(getIt()))
    ..registerLazySingleton<KitsuClient>(() => KitsuClient(getIt()))
    ..registerLazySingleton<AnimeDetailsGateway>(
      () => AnimeDetailsGatewayImpl(getIt()),
    )
    ..registerLazySingleton<AnimeCatalogueGateway>(
      () => AnimeCatalogueGatewayImpl(getIt()),
    )
    ..registerLazySingleton<LoadWatchlistUseCase>(
      () => LoadWatchlistUseCase(getIt<AnimeDetailsGateway>()),
    )
    ..registerLazySingleton<BrowseCatalogueUseCase>(
      () => BrowseCatalogueUseCase(getIt<AnimeCatalogueGateway>()),
    )
    ..registerFactory<WatchlistCubit>(
      () => WatchlistCubit(getIt<LoadWatchlistUseCase>(), MyWatchlist.entries),
    )
    ..registerFactory<CatalogueCubit>(
      () => CatalogueCubit(getIt<BrowseCatalogueUseCase>()),
    );
}
