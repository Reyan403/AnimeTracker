import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Anime/domain/use_cases/load_watchlist_use_case.dart';
import 'package:monapp/layers/functional/Anime/presentation/cubit/watchlist_cubit.dart';
import 'package:monapp/layers/technical/Injection/injection.dart';
import 'package:monapp/main.dart';

import 'fake_anime_details_gateway.dart';

const entries = [
  WatchlistEntry(malId: 1, title: 'Cowboy Bebop', status: WatchStatus.toWatch),
];

Future<void> pumpShell(WidgetTester tester) async {
  await getIt.reset();
  getIt
    ..registerLazySingleton<LoadWatchlistUseCase>(
      () => const LoadWatchlistUseCase(FakeAnimeDetailsGateway({})),
    )
    ..registerFactory<WatchlistCubit>(
      () => WatchlistCubit(getIt<LoadWatchlistUseCase>(), entries),
    );

  await tester.pumpWidget(const AnimeTrackerApp());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('both menus are reachable from the bottom bar', (tester) async {
    await pumpShell(tester);

    expect(find.text('Liste'), findsOneWidget);
    expect(find.text('Catalogue'), findsWidgets);
  });

  testWidgets('the app opens on the Liste menu', (tester) async {
    await pumpShell(tester);

    expect(find.text('Ma liste'), findsOneWidget);
  });

  testWidgets('tapping Catalogue swaps the visible screen', (tester) async {
    await pumpShell(tester);

    await tester.tap(find.text('Catalogue'));
    await tester.pumpAndSettle();

    expect(find.text('Rien à explorer pour le moment.'), findsOneWidget);
  });

  testWidgets('coming back to Liste keeps it loaded', (tester) async {
    await pumpShell(tester);

    await tester.tap(find.text('Catalogue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Liste'));
    await tester.pumpAndSettle();

    expect(find.text('Ma liste'), findsOneWidget);
  });
}
