import 'package:flutter/material.dart';

import '../app_motion.dart';
import '../app_spacing.dart';
import 'anime_plaque.dart';

class AnimePoster extends StatelessWidget {
  const AnimePoster({
    required this.title,
    this.imageUrl,
    this.heroTag,
    this.width = AppSpacing.plaqueWidth,
    this.height = AppSpacing.plaqueHeight,
    super.key,
  });

  static String heroTagFor(String origin, int animeId) =>
      'poster-$origin-$animeId';

  final String title;
  final String? imageUrl;
  final String? heroTag;
  final double width;
  final double height;

  Widget _image(BuildContext context, String url) {
    return Image.network(
      url,
      key: ValueKey(url),
      width: width,
      height: height,
      fit: BoxFit.cover,
      cacheWidth: (width * 2).round(),
      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
      errorBuilder: (context, error, stackTrace) => AnimePlaque(title: title),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame == null && !wasSynchronouslyLoaded) {
          return AnimePlaque(title: title);
        }

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: AppMotion.resolve(context, AppMotion.standard),
          builder: (context, opacity, _) =>
              Opacity(opacity: opacity, child: child),
        );
      },
      excludeFromSemantics: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final poster = ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: SizedBox(
        width: width,
        height: height,
        child: url == null || url.isEmpty
            ? AnimePlaque(title: title)
            : _image(context, url),
      ),
    );
    final tag = heroTag;

    return tag == null ? poster : Hero(tag: tag, child: poster);
  }
}
