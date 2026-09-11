import 'package:flutter/material.dart';

import '../app_spacing.dart';
import 'anime_plaque.dart';

class AnimePoster extends StatelessWidget {
  const AnimePoster({required this.title, this.imageUrl, super.key});

  static const int _decodedWidth = 2 * AppSpacing.plaqueWidth ~/ 1;

  final String title;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    if (url == null || url.isEmpty) {
      return AnimePlaque(title: title);
    }

    return Image.network(
      url,
      width: AppSpacing.plaqueWidth,
      height: AppSpacing.plaqueHeight,
      fit: BoxFit.cover,
      cacheWidth: _decodedWidth,
      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
      errorBuilder: (context, error, stackTrace) => AnimePlaque(title: title),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
          frame == null && !wasSynchronouslyLoaded
              ? AnimePlaque(title: title)
              : child,
      excludeFromSemantics: true,
    );
  }
}
