import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/gateways/anime_details_gateway.dart';

class CountingAnimeDetailsGateway implements AnimeDetailsGateway {
  CountingAnimeDetailsGateway(this.details, {required this.answerDelay});

  final AnimeDetails details;
  final Duration answerDelay;

  int _pending = 0;
  int mostPendingAtOnce = 0;

  @override
  Future<AnimeDetails> findById(int id) async {
    _pending++;

    if (_pending > mostPendingAtOnce) {
      mostPendingAtOnce = _pending;
    }

    await Future<void>.delayed(answerDelay);
    _pending--;

    return details;
  }
}
