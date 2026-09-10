import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../functional/Anime/data/data_sources/jikan_client.dart';
import '../../functional/Anime/data/gateways/anime_details_gateway_impl.dart';
import '../../functional/Anime/data/my_watchlist.dart';
import '../../functional/Anime/domain/gateways/anime_details_gateway.dart';
import '../../functional/Anime/domain/use_cases/load_watchlist_use_case.dart';
import '../../functional/Anime/presentation/cubit/watchlist_cubit.dart';

final GetIt getIt = GetIt.instance;

void initializeDependencies() {
  if (getIt.isRegistered<LoadWatchlistUseCase>()) {
    return;
  }

  getIt
    ..registerLazySingleton<http.Client>(http.Client.new)
    ..registerLazySingleton<JikanClient>(() => JikanClient(getIt()))
    ..registerLazySingleton<AnimeDetailsGateway>(
      () => AnimeDetailsGatewayImpl(getIt()),
    )
    ..registerLazySingleton<LoadWatchlistUseCase>(
      () => LoadWatchlistUseCase(getIt<AnimeDetailsGateway>()),
    )
    ..registerFactory<WatchlistCubit>(
      () => WatchlistCubit(getIt<LoadWatchlistUseCase>(), MyWatchlist.entries),
    );
}
