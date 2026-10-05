import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../functional/Agenda/domain/use_cases/load_release_agenda_use_case.dart';
import '../../functional/Agenda/presentation/cubit/agenda_cubit.dart';
import '../../functional/Agenda/data/gateways/anilist_release_schedule_gateway.dart';
import '../../functional/Agenda/domain/gateways/release_schedule_gateway.dart';
import '../../functional/Anime/data/gateways/anime_details_gateway_impl.dart';
import '../../functional/Discover/data/gateways/kitsu_catalogue_suggestion_gateway.dart';
import '../../functional/Discover/data/gateways/kitsu_recommendation_gateway.dart';
import '../../functional/Discover/domain/gateways/catalogue_suggestion_gateway.dart';
import '../../functional/Discover/domain/gateways/recommendation_gateway.dart';
import '../../functional/Discover/domain/use_cases/recommend_anime_use_case.dart';
import '../../functional/Discover/domain/use_cases/suggest_evening_watch_use_case.dart';
import '../../functional/Discover/presentation/cubit/evening_cubit.dart';
import '../../functional/Discover/presentation/cubit/recommendations_cubit.dart';
import '../../functional/Settings/data/preferences_settings_gateway.dart';
import '../../functional/Settings/domain/gateways/settings_gateway.dart';
import '../../functional/Settings/domain/use_cases/change_spoiler_guard_use_case.dart';
import '../../functional/Settings/domain/use_cases/read_spoiler_guard_use_case.dart';
import '../../functional/Settings/presentation/cubit/settings_cubit.dart';
import '../../functional/Stats/domain/use_cases/compute_watch_stats_use_case.dart';
import '../../functional/Stats/presentation/cubit/stats_cubit.dart';
import '../../functional/Anime/data/gateways/local_watchlist_gateway.dart';
import '../../functional/Anime/data/stores/preferences_anime_details_cache.dart';
import '../../functional/Anime/domain/gateways/anime_details_cache.dart';
import '../../functional/Anime/domain/use_cases/find_watch_status_use_case.dart';
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
import '../../functional/Catalogue/data/stores/preferences_anime_sheet_cache.dart';
import '../../functional/Catalogue/domain/gateways/anime_sheet_cache.dart';
import '../../functional/Catalogue/data/gateways/french_synopsis_gateway_impl.dart';
import '../../functional/Catalogue/domain/gateways/anime_catalogue_gateway.dart';
import '../../functional/Catalogue/domain/gateways/anime_sheet_gateway.dart';
import '../../functional/Catalogue/domain/gateways/french_synopsis_gateway.dart';
import '../../functional/Catalogue/domain/use_cases/browse_catalogue_use_case.dart';
import '../../functional/Catalogue/domain/use_cases/load_anime_sheet_use_case.dart';
import '../../functional/Catalogue/presentation/cubit/anime_sheet_cubit.dart';
import '../../functional/Catalogue/presentation/cubit/catalogue_cubit.dart';
import '../AniListApi/anilist_client.dart';
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
    ..registerLazySingleton<AniListClient>(() => AniListClient(getIt()))
    ..registerLazySingleton<ReleaseScheduleGateway>(
      () => AniListReleaseScheduleGateway(getIt()),
    )
    ..registerLazySingleton<TmdbClient>(
      () => TmdbClient(getIt(), apiKey: tmdbApiKey),
    )
    ..registerLazySingleton<AnimeDetailsGateway>(
      () => AnimeDetailsGatewayImpl(getIt()),
    )
    ..registerLazySingleton<AnimeDetailsCache>(
      () => PreferencesAnimeDetailsCache(getIt()),
    )
    ..registerLazySingleton<AnimeSheetCache>(
      () => PreferencesAnimeSheetCache(getIt()),
    )
    ..registerLazySingleton<SettingsGateway>(
      () => PreferencesSettingsGateway(getIt()),
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
        getIt<AnimeDetailsCache>(),
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
      () => LoadReleaseAgendaUseCase(
        getIt<LoadWatchlistUseCase>(),
        getIt<ReleaseScheduleGateway>(),
      ),
    )
    ..registerLazySingleton<ComputeWatchStatsUseCase>(
      () => ComputeWatchStatsUseCase(getIt<LoadWatchlistUseCase>()),
    )
    ..registerLazySingleton<RecommendationGateway>(
      () => KitsuRecommendationGateway(getIt()),
    )
    ..registerLazySingleton<RecommendAnimeUseCase>(
      () => RecommendAnimeUseCase(
        getIt<LoadWatchlistUseCase>(),
        getIt<RecommendationGateway>(),
      ),
    )
    ..registerLazySingleton<CatalogueSuggestionGateway>(
      () => KitsuCatalogueSuggestionGateway(getIt()),
    )
    ..registerLazySingleton<SuggestEveningWatchUseCase>(
      () => SuggestEveningWatchUseCase(
        getIt<CatalogueSuggestionGateway>(),
        getIt<FindWatchStatusUseCase>(),
      ),
    )
    ..registerLazySingleton<LoadAnimeSheetUseCase>(
      () => LoadAnimeSheetUseCase(
        getIt<AnimeSheetGateway>(),
        getIt<FrenchSynopsisGateway>(),
        getIt<AnimeSheetCache>(),
      ),
    )
    ..registerLazySingleton<FindWatchStatusUseCase>(
      () => FindWatchStatusUseCase(getIt<WatchlistGateway>()),
    )
    ..registerLazySingleton<ReadSpoilerGuardUseCase>(
      () => ReadSpoilerGuardUseCase(getIt<SettingsGateway>()),
    )
    ..registerLazySingleton<ChangeSpoilerGuardUseCase>(
      () => ChangeSpoilerGuardUseCase(getIt<SettingsGateway>()),
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
    ..registerFactory<StatsCubit>(
      () => StatsCubit(getIt<ComputeWatchStatsUseCase>()),
    )
    ..registerFactory<RecommendationsCubit>(
      () => RecommendationsCubit(
        getIt<RecommendAnimeUseCase>(),
        getIt<AddToWatchlistUseCase>(),
      ),
    )
    ..registerFactory<EveningCubit>(
      () => EveningCubit(
        getIt<SuggestEveningWatchUseCase>(),
        getIt<AddToWatchlistUseCase>(),
      ),
    )
    ..registerFactory<AgendaCubit>(
      () => AgendaCubit(getIt<LoadReleaseAgendaUseCase>()),
    )
    ..registerFactory<AnimeSheetCubit>(
      () => AnimeSheetCubit(
        getIt<LoadAnimeSheetUseCase>(),
        getIt<FindWatchStatusUseCase>(),
        getIt<ReadSpoilerGuardUseCase>(),
      ),
    )
    ..registerFactory<SettingsCubit>(
      () => SettingsCubit(
        getIt<ReadSpoilerGuardUseCase>(),
        getIt<ChangeSpoilerGuardUseCase>(),
      ),
    )
    ..registerFactory<CatalogueCubit>(
      () => CatalogueCubit(
        getIt<BrowseCatalogueUseCase>(),
        getIt<AddToWatchlistUseCase>(),
        getIt<ListedAnimeIdsUseCase>(),
      ),
    );
}
