import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_colors.dart';

class AnimeSheetCover extends StatelessWidget {
  const AnimeSheetCover({required this.imageUrl, super.key});

  static const double height = 180;

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    if (url == null || url.isEmpty) {
      return const SizedBox.shrink();
    }

    return Image.network(
      url,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
          frame == null && !wasSynchronouslyLoaded
              ? Container(height: height, color: AppColors.plaqueBackground)
              : child,
      excludeFromSemantics: true,
    );
  }
}
