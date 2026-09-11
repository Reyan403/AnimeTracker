import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/anime_sheet.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/anime_sheet_view.dart';
import 'package:monapp/layers/functional/Catalogue/domain/use_cases/load_anime_sheet_use_case.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/anime_sheet_cubit.dart';
import 'package:monapp/layers/technical/Injection/injection.dart';

import 'fake_anime_sheet_gateway.dart';
import 'fake_french_synopsis_gateway.dart';

const onePiece = AnimeSheet(
  id: 12,
  title: 'One Piece',
  format: 'Série TV',
  synopsis: 'Gol D. Roger était connu comme le Roi des Pirates.',
  status: 'En cours de diffusion',
  startYear: 1999,
  episodeCount: 1000,
  episodeMinutes: 24,
  totalMinutes: 33624,
  rating: 84,
  ratingRank: 58,
  popularityRank: 14,
  memberCount: 324212,
  favoriteCount: 10749,
  ageRating: 'Déconseillé aux moins de 13 ans',
);

Future<void> pumpSheet(WidgetTester tester, FakeAnimeSheetGateway gateway) async {
  await getIt.reset();
  getIt.registerFactory<AnimeSheetCubit>(
    () => AnimeSheetCubit(
      LoadAnimeSheetUseCase(gateway, FakeFrenchSynopsisGateway()),
    ),
  );

  await tester.pumpWidget(
    const MaterialApp(home: AnimeSheetView(animeId: 12, title: 'One Piece')),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('it tells the story of the anime', (tester) async {
    await pumpSheet(
      tester,
      FakeAnimeSheetGateway(sheetsById: const {12: onePiece}),
    );

    expect(find.text('Synopsis'), findsOneWidget);
    expect(
      find.text('Gol D. Roger était connu comme le Roi des Pirates.'),
      findsOneWidget,
    );
  });

  testWidgets('it lists everything the API knows', (tester) async {
    await pumpSheet(
      tester,
      FakeAnimeSheetGateway(sheetsById: const {12: onePiece}),
    );

    expect(find.text('Série TV'), findsOneWidget);
    expect(find.text('En cours de diffusion'), findsOneWidget);
    expect(find.text('1999'), findsOneWidget);
    expect(find.text('1 000 épisodes de 24 min'), findsOneWidget);
    expect(find.text('560 h'), findsOneWidget);
    expect(find.text('84 %'), findsOneWidget);
    expect(find.text('58e'), findsOneWidget);
    expect(find.text('14e'), findsOneWidget);
    expect(find.text('324 212'), findsOneWidget);
    expect(find.text('10 749'), findsOneWidget);
    expect(find.text('Déconseillé aux moins de 13 ans'), findsOneWidget);
  });

  testWidgets('what the API ignores is left out', (tester) async {
    await pumpSheet(
      tester,
      FakeAnimeSheetGateway(
        sheetsById: const {
          12: AnimeSheet(id: 12, title: 'One Piece', format: 'Série TV'),
        },
      ),
    );

    expect(find.text('Synopsis'), findsNothing);
    expect(find.text('Format'), findsOneWidget);
    expect(find.text('Statut'), findsNothing);
    expect(find.text('Note moyenne'), findsNothing);
  });

  testWidgets('an unreachable sheet offers a retry', (tester) async {
    await pumpSheet(tester, FakeAnimeSheetGateway());

    expect(find.text('Impossible de charger la fiche'), findsOneWidget);
    expect(find.text('Réessayer'), findsOneWidget);
  });
}
