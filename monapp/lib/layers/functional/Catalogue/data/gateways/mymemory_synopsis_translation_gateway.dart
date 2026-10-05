import '../../../../technical/MyMemoryApi/mymemory_client.dart';
import '../../domain/gateways/synopsis_translation_gateway.dart';
import '../models/translation_dto.dart';

class MyMemorySynopsisTranslationGateway
    implements SynopsisTranslationGateway {
  const MyMemorySynopsisTranslationGateway(this._client);

  final MyMemoryClient _client;

  @override
  Future<String?> translateToFrench(String text) async {
    final paragraphs = [
      for (final paragraph in text.split(RegExp(r'\n+')))
        if (paragraph.trim().isNotEmpty)
          TranslationDto.chunksOf(paragraph.trim()),
    ];

    if (paragraphs.isEmpty) {
      return null;
    }

    try {
      final translated = await Future.wait([
        for (final chunks in paragraphs) _translateAll(chunks),
      ]);

      return translated.contains(null) ? null : translated.join('\n\n');
    } catch (_) {
      return null;
    }
  }

  Future<String?> _translateAll(List<String> chunks) async {
    final pieces = await Future.wait([
      for (final chunk in chunks)
        _client
            .translate(chunk, from: 'en', to: 'fr')
            .then(TranslationDto.textFrom),
    ]);

    return pieces.contains(null) ? null : pieces.join(' ');
  }
}
