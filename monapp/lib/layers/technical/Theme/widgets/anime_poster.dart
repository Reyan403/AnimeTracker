import 'package:cached_network_image_ce/cached_network_image.dart';
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

    return CachedNetworkImage(
      imageUrl: url,
      width: AppSpacing.plaqueWidth,
      height: AppSpacing.plaqueHeight,
      fit: BoxFit.cover,
      memCacheWidth: _decodedWidth,
      placeholder: (context, address) => AnimePlaque(title: title),
      errorBuilder: (context, error, stackTrace) => AnimePlaque(title: title),
    );
  }
}
