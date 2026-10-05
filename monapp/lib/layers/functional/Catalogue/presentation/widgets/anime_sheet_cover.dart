import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_palette.dart';

class AnimeSheetCover extends StatelessWidget {
  const AnimeSheetCover({required this.imageUrl, super.key});

  static const double height = 220;

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final fallback = AppPalette.of(context).posterFallback;

    if (url == null || url.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            url,
            fit: BoxFit.cover,
            webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
            errorBuilder: (context, error, stackTrace) =>
                ColoredBox(color: fallback),
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                frame == null && !wasSynchronouslyLoaded
                    ? ColoredBox(color: fallback)
                    : child,
            excludeFromSemantics: true,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
