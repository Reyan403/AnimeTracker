import 'package:cached_network_image_ce/cached_network_image.dart';
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

    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      memCacheHeight: 2 * height ~/ 1,
      placeholder: (context, address) =>
          Container(height: height, color: AppColors.plaqueBackground),
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
