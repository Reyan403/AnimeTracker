import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/anime_sheet.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/anime_sheet_cubit.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/anime_sheet_state.dart';

import 'fake_anime_sheet_gateway.dart';

const onePiece = AnimeSheet(
  id: 12,
  title: 'One Piece',
  format: 'Série TV',
  synopsis: 'Gol D. Roger était connu comme le Roi des Pirates.',
);

void main() {
  test('it loads the sheet of the asked anime', () async {
    final gateway = FakeAnimeSheetGateway(sheetsById: const {12: onePiece});
    final cubit = AnimeSheetCubit(gateway);

    await cubit.load(12);

    expect(cubit.state.status, AnimeSheetStatus.success);
    expect(cubit.state.sheet, onePiece);
    expect(gateway.receivedIds, [12]);
  });

  test('an unknown anime leaves the sheet in failure', () async {
    final cubit = AnimeSheetCubit(FakeAnimeSheetGateway());

    await cubit.load(12);

    expect(cubit.state.status, AnimeSheetStatus.failure);
  });

  test('an unexpected failure is reported too', () async {
    final cubit = AnimeSheetCubit(FakeAnimeSheetGateway(crashes: true));

    await cubit.load(12);

    expect(cubit.state.status, AnimeSheetStatus.failure);
  });

  test('a retry starts over from the loading state', () async {
    final cubit = AnimeSheetCubit(
      FakeAnimeSheetGateway(sheetsById: const {12: onePiece}),
    );
    await cubit.load(12);

    final states = expectLater(
      cubit.stream,
      emitsInOrder(const [
        AnimeSheetState(),
        AnimeSheetState(status: AnimeSheetStatus.success, sheet: onePiece),
      ]),
    );

    await cubit.load(12);
    await cubit.close();
    await states;
  });
}
