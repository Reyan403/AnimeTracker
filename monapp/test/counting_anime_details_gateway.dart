import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/gateways/anime_details_gateway.dart';

class CountingAnimeDetailsGateway implements AnimeDetailsGateway {
  CountingAnimeDetailsGateway(this.details, {required this.answerDelay});

  final AnimeDetails details;
  final Duration answerDelay;

  int requests = 0;

  @override
  Future<Map<int, AnimeDetails>> findAllByIds(List<int> ids) async {
    requests++;
    await Future<void>.delayed(answerDelay);

    return {for (final id in ids) id: details};
  }
}
