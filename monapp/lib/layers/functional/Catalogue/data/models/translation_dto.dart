abstract final class TranslationDto {
  static const String quotaWarning = 'MYMEMORY WARNING';

  static const Map<String, String> _entities = {
    '&#39;': "'",
    '&quot;': '"',
    '&amp;': '&',
    '&lt;': '<',
    '&gt;': '>',
  };

  static String? textFrom(Map<String, dynamic> json) {
    final data = json['responseData'] as Map<String, dynamic>?;
    final text = data?['translatedText'] as String?;
    final status = int.tryParse('${json['responseStatus']}');

    if (text == null ||
        json['quotaFinished'] == true ||
        (status != null && status != 200) ||
        text.isEmpty ||
        text.startsWith(quotaWarning)) {
      return null;
    }

    var unescaped = text;

    for (final entity in _entities.entries) {
      unescaped = unescaped.replaceAll(entity.key, entity.value);
    }

    return unescaped;
  }

  static List<String> chunksOf(String paragraph, {int maxLength = 450}) {
    final sentences = paragraph.trim().split(RegExp(r'(?<=[.!?])\s+'));
    final chunks = <String>[];
    var current = '';

    for (final sentence in sentences) {
      for (final piece in _slice(sentence, maxLength)) {
        if (current.isNotEmpty && current.length + piece.length + 1 > maxLength) {
          chunks.add(current);
          current = piece;
        } else {
          current = current.isEmpty ? piece : '$current $piece';
        }
      }
    }

    if (current.isNotEmpty) {
      chunks.add(current);
    }

    return chunks;
  }

  static List<String> _slice(String sentence, int maxLength) => [
        for (var start = 0; start < sentence.length; start += maxLength)
          sentence.substring(
            start,
            start + maxLength > sentence.length
                ? sentence.length
                : start + maxLength,
          ),
      ];
}
