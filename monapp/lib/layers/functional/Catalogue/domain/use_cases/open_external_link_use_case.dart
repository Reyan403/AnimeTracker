import '../gateways/link_opener_gateway.dart';

class OpenExternalLinkUseCase {
  const OpenExternalLinkUseCase(this._opener);

  static const String trailerBase = 'https://www.youtube.com/watch?v=';

  final LinkOpenerGateway _opener;

  Future<bool> call(String url) => _opener.open(Uri.parse(url));

  Future<bool> openTrailer(String youtubeVideoId) =>
      call('$trailerBase$youtubeVideoId');
}
