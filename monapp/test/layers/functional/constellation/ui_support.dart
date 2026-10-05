import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime_genre.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/anime_sheet_cubit.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/anime_sheet_state.dart';
import 'package:monapp/layers/functional/Constellation/domain/entities/constellation.dart';
import 'package:monapp/layers/functional/Constellation/domain/entities/constellation_link.dart';
import 'package:monapp/layers/functional/Constellation/domain/entities/constellation_star.dart';
import 'package:monapp/layers/functional/Constellation/domain/use_cases/build_constellation_use_case.dart';

const sampleConstellation = Constellation(
  stars: [
    ConstellationStar(
      animeId: 1,
      title: 'Étoile terminée',
      status: WatchStatus.completed,
      x: 0.2,
      y: 0.3,
      weight: 1,
      genreSlug: 'action',
    ),
    ConstellationStar(
      animeId: 2,
      title: 'Étoile en cours',
      status: WatchStatus.watching,
      x: 0.7,
      y: 0.4,
      weight: 0.7,
      genreSlug: 'drama',
    ),
    ConstellationStar(
      animeId: 3,
      title: 'Étoile solitaire',
      status: WatchStatus.toWatch,
      x: 0.5,
      y: 0.8,
      weight: 0.35,
    ),
  ],
  links: [
    ConstellationLink(fromId: 1, toId: 2, sharedGenres: 2),
    ConstellationLink(fromId: 2, toId: 3, sharedGenres: 1),
  ],
  genres: [
    AnimeGenre(slug: 'action', title: 'Action'),
    AnimeGenre(slug: 'drama', title: 'Drame'),
  ],
);

const emptyConstellation = Constellation(stars: [], links: [], genres: []);

class FakeBuildConstellation implements BuildConstellationUseCase {
  FakeBuildConstellation(this._stream);

  final Stream<Constellation> Function() _stream;
  int calls = 0;

  @override
  Stream<Constellation> call() {
    calls++;

    return _stream();
  }
}

class FakeSheetCubit extends Cubit<AnimeSheetState> implements AnimeSheetCubit {
  FakeSheetCubit() : super(const AnimeSheetState());

  @override
  Future<void> load(int id) async {}

  @override
  void revealSynopsis() {}
}
