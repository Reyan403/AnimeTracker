import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/anime_extras.dart';
import '../../domain/use_cases/load_anime_extras_use_case.dart';
import '../../domain/use_cases/open_external_link_use_case.dart';

enum AnimeExtrasStatus { loading, ready }

class AnimeExtrasState extends Equatable {
  const AnimeExtrasState({
    this.status = AnimeExtrasStatus.loading,
    this.extras = AnimeExtras.none,
    this.linkFailed = false,
  });

  final AnimeExtrasStatus status;
  final AnimeExtras extras;
  final bool linkFailed;

  @override
  List<Object?> get props => [status, extras, linkFailed];
}

class AnimeExtrasCubit extends Cubit<AnimeExtrasState> {
  AnimeExtrasCubit(this._loadExtras, this._openLink)
      : super(const AnimeExtrasState());

  final LoadAnimeExtrasUseCase _loadExtras;
  final OpenExternalLinkUseCase _openLink;

  Future<void> load(int animeId) async {
    final extras = await _loadExtras(animeId);

    if (!isClosed) {
      emit(AnimeExtrasState(status: AnimeExtrasStatus.ready, extras: extras));
    }
  }

  Future<void> openTrailer(String youtubeVideoId) =>
      _report(_openLink.openTrailer(youtubeVideoId));

  Future<void> openStreaming(StreamingLink link) =>
      _report(_openLink(link.url));

  Future<void> _report(Future<bool> opening) async {
    final opened = await opening;

    if (!isClosed) {
      emit(
        AnimeExtrasState(
          status: state.status,
          extras: state.extras,
          linkFailed: !opened,
        ),
      );
    }
  }
}
