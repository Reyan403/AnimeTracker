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
        if (paragraph.trim().isNotEmpty) paragraph.trim(),
    ];
    final translated = <String>[];

    try {
      for (final paragraph in paragraphs) {
        final pieces = <String>[];

        for (final chunk in TranslationDto.chunksOf(paragraph)) {
          final piece = TranslationDto.textFrom(
            await _client.translate(chunk, from: 'en', to: 'fr'),
          );

          if (piece == null) {
            return null;
          }

          pieces.add(piece);
        }

        translated.add(pieces.join(' '));
      }
    } catch (_) {
      return null;
    }

    return translated.isEmpty ? null : translated.join('\n\n');
  }
}
