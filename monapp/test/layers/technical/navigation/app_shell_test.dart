import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Agenda/presentation/cubit/agenda_cubit.dart';
import 'package:monapp/layers/functional/Agenda/presentation/cubit/agenda_state.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/presentation/cubit/watchlist_cubit.dart';
import 'package:monapp/layers/functional/Anime/presentation/cubit/watchlist_state.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/anime_sheet.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/catalogue_anime.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/anime_sheet_cubit.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/anime_sheet_state.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/catalogue_cubit.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/catalogue_state.dart';
import 'package:monapp/layers/functional/Discover/domain/entities/evening_duration.dart';
import 'package:monapp/layers/functional/Discover/domain/entities/evening_mood.dart';
import 'package:monapp/layers/functional/Discover/presentation/cubit/evening_cubit.dart';
import 'package:monapp/layers/functional/Discover/presentation/cubit/evening_state.dart';
import 'package:monapp/layers/functional/Discover/presentation/cubit/recommendations_cubit.dart';
import 'package:monapp/layers/functional/Discover/presentation/cubit/recommendations_state.dart';
import 'package:monapp/layers/functional/Settings/presentation/cubit/settings_cubit.dart';
import 'package:monapp/layers/functional/Stats/presentation/cubit/stats_cubit.dart';
import 'package:monapp/layers/functional/Stats/presentation/cubit/stats_state.dart';
import 'package:monapp/layers/technical/Injection/injection.dart';
import 'package:monapp/layers/technical/Navigation/app_shell.dart';

import '../../../support/pump_app.dart';

class FakeWatchlistCubit extends Cubit<WatchlistState>
    implements WatchlistCubit {
  FakeWatchlistCubit()
      : super(
          const WatchlistState(
            status: ViewStatus.success,
            animes: [
              Anime(id: 1, title: 'Monster', status: WatchStatus.watching),
            ],
          ),
        );

  @override
  Future<void> load() async {}

  @override
  void changeStatus(int animeId, WatchStatus status) {}

  @override
  void watchNextEpisode(Anime anime) {}

  @override
  void watchPreviousEpisode(Anime anime) {}

  @override
  void selectStatus(WatchStatus status) =>
      emit(state.copyWith(selected: status));
}

class FakeSettingsCubit extends Cubit<SettingsState> implements SettingsCubit {
  FakeSettingsCubit() : super(const SettingsState(isSpoilerGuardEnabled: true));

  @override
  void changeSpoilerGuard({required bool enabled}) {}
}

class FakeStatsCubit extends Cubit<StatsState> implements StatsCubit {
  FakeStatsCubit() : super(const StatsState(status: StatsStatus.empty));

  @override
  Future<void> load() async {}
}

class FakeRecommendationsCubit extends Cubit<RecommendationsState>
    implements RecommendationsCubit {
  FakeRecommendationsCubit()
      : super(
          const RecommendationsState(status: RecommendationsStatus.empty),
        );

  @override
  Future<void> load() async {}

  @override
  void add(CatalogueAnime anime) {}
}

class FakeEveningCubit extends Cubit<EveningState> implements EveningCubit {
  FakeEveningCubit() : super(const EveningState());

  @override
  void selectMood(EveningMood mood) {}

  @override
  void selectDuration(EveningDuration duration) {}

  @override
  Future<void> suggest() async {}

  @override
  Future<void> suggestAnother() async {}
}

class FakeAgendaCubit extends Cubit<AgendaState> implements AgendaCubit {
  FakeAgendaCubit() : super(const AgendaState(status: AgendaStatus.empty));

  @override
  Future<void> load() async {}

  @override
  void selectFilter({required bool onlyWatchlist}) {}
}

class FakeCatalogueCubit extends Cubit<CatalogueState>
    implements CatalogueCubit {
  FakeCatalogueCubit()
      : super(
          const CatalogueState(
            status: CatalogueStatus.success,
            animes: [
              CatalogueAnime(
                id: 9,
                title: 'Berserk',
                format: 'TV',
                year: 1997,
                episodeCount: 25,
              ),
            ],
          ),
        );

  @override
  Future<void> load() async {}

  @override
  void addToWatchlist(CatalogueAnime anime) {}

  @override
  void search(String query) {}

  @override
  Future<void> clear() async {}

  @override
  Future<void> loadMore() async {}
}

class FakeAnimeSheetCubit extends Cubit<AnimeSheetState>
    implements AnimeSheetCubit {
  FakeAnimeSheetCubit()
      : super(
          const AnimeSheetState(
            status: AnimeSheetStatus.success,
            sheet: AnimeSheet(
              id: 1,
              title: 'Monster',
              format: 'TV',
              synopsis: 'Un thriller.',
            ),
          ),
        );

  @override
  Future<void> load(int id) async {}

  @override
  void revealSynopsis() {}
}

void main() {
  setUp(() {
    getIt
      ..registerFactory<WatchlistCubit>(FakeWatchlistCubit.new)
      ..registerFactory<SettingsCubit>(FakeSettingsCubit.new)
      ..registerFactory<StatsCubit>(FakeStatsCubit.new)
      ..registerFactory<RecommendationsCubit>(FakeRecommendationsCubit.new)
      ..registerFactory<EveningCubit>(FakeEveningCubit.new)
      ..registerFactory<AgendaCubit>(FakeAgendaCubit.new)
      ..registerFactory<CatalogueCubit>(FakeCatalogueCubit.new)
      ..registerFactory<AnimeSheetCubit>(FakeAnimeSheetCubit.new);
  });

  tearDown(getIt.reset);

  testWidgets('barre de navigation basse sur un écran étroit', (tester) async {
    await pumpApp(tester, const AppShell());

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('rail de navigation sur un écran large', (tester) async {
    await pumpApp(tester, const AppShell(), size: const Size(1200, 800));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('change d onglet avec un fondu', (tester) async {
    await pumpApp(tester, const AppShell());

    expect(find.text('Ma liste'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Catalogue'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.hasRunningAnimations, isTrue);

    await tester.pumpAndSettle();

    expect(find.text('Berserk'), findsOneWidget);
  });

  testWidgets('ouvre la fiche depuis Ma liste', (tester) async {
    await pumpApp(tester, const AppShell());

    await tester.tap(find.text('Monster'));
    await tester.pumpAndSettle();

    expect(find.text('Un thriller.'), findsOneWidget);
    expect(find.text('Synopsis'), findsOneWidget);
  });

  testWidgets('ouvre la fiche depuis le catalogue', (tester) async {
    await pumpApp(tester, const AppShell());

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Catalogue'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Berserk'));
    await tester.pumpAndSettle();

    expect(find.text('Un thriller.'), findsOneWidget);
  });

  testWidgets('la vue Ma liste change d onglet de statut', (tester) async {
    await pumpApp(tester, const AppShell());

    expect(find.text('Monster'), findsOneWidget);

    await tester.tap(find.text('À voir'));
    await tester.pumpAndSettle();

    expect(find.text('Monster'), findsNothing);
  });
}
