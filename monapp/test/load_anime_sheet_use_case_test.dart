import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/anime_sheet.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/anime_catalogue_gateway.dart';
import 'package:monapp/layers/functional/Catalogue/domain/use_cases/load_anime_sheet_use_case.dart';

import 'fake_anime_sheet_gateway.dart';
import 'fake_french_synopsis_gateway.dart';

const onePiece = AnimeSheet(
  id: 12,
  title: 'One Piece',
  format: 'Série TV',
  synopsis: 'Gol D. Roger was known as the Pirate King.',
  rating: 84,
);

const frenchSynopsis = 'Gol D. Roger était connu comme le Roi des Pirates.';

LoadAnimeSheetUseCase useCaseWith(FakeFrenchSynopsisGateway french) =>
    LoadAnimeSheetUseCase(
      FakeAnimeSheetGateway(sheetsById: const {12: onePiece}),
      french,
    );

void main() {
  test('it replaces the synopsis by its French version', () async {
    final french = FakeFrenchSynopsisGateway(
      synopsesByTitle: const {'One Piece': frenchSynopsis},
    );

    final sheet = await useCaseWith(french)(12);

    expect(sheet.synopsis, frenchSynopsis);
    expect(french.receivedTitles, ['One Piece']);
  });

  test('it keeps everything else of the sheet', () async {
    final sheet = await useCaseWith(
      FakeFrenchSynopsisGateway(
        synopsesByTitle: const {'One Piece': frenchSynopsis},
      ),
    )(12);

    expect(sheet.id, 12);
    expect(sheet.title, 'One Piece');
    expect(sheet.rating, 84);
  });

  test('without French version the original synopsis stays', () async {
    final sheet = await useCaseWith(FakeFrenchSynopsisGateway())(12);

    expect(sheet.synopsis, startsWith('Gol D. Roger was known'));
  });

  test('a failing translation service does not lose the sheet', () async {
    final sheet = await useCaseWith(FakeFrenchSynopsisGateway(isDown: true))(12);

    expect(sheet.title, 'One Piece');
    expect(sheet.synopsis, startsWith('Gol D. Roger was known'));
  });

  test('an unreachable sheet is still reported', () async {
    final useCase = LoadAnimeSheetUseCase(
      FakeAnimeSheetGateway(),
      FakeFrenchSynopsisGateway(),
    );

    expect(() => useCase(12), throwsA(isA<CatalogueUnavailableException>()));
  });
}
