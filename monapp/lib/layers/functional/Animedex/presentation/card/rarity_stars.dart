import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_palette.dart';
import '../../domain/entities/card_rarity.dart';
import 'rarity_style.dart';

class RarityStars extends StatelessWidget {
  const RarityStars({required this.rarity, this.size = 16, super.key});

  final CardRarity rarity;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < rarity.stars; index++)
            Icon(Icons.star_rounded, size: size, color: palette.sun),
        ],
      ),
    );
  }
}
