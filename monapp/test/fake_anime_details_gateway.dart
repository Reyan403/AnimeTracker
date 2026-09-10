import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/gateways/anime_details_gateway.dart';

class FakeAnimeDetailsGateway implements AnimeDetailsGateway {
  const FakeAnimeDetailsGateway(this.detailsByMalId);

  final Map<int, AnimeDetails> detailsByMalId;

  @override
  Future<AnimeDetails> findByMalId(int malId) async {
    final details = detailsByMalId[malId];

    if (details == null) {
      throw AnimeDetailsUnavailableException(malId);
    }

    return details;
  }
}
