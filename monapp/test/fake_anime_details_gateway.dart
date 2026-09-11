import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/gateways/anime_details_gateway.dart';

class FakeAnimeDetailsGateway implements AnimeDetailsGateway {
  const FakeAnimeDetailsGateway(this.detailsByMalId);

  final Map<int, AnimeDetails> detailsByMalId;

  @override
  Future<AnimeDetails> findById(int id) async {
    final details = detailsByMalId[id];

    if (details == null) {
      throw AnimeDetailsUnavailableException(id);
    }

    return details;
  }
}
