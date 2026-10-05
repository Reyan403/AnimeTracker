import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_palette.dart';
import '../card/card_metrics.dart';

class CardBack extends StatelessWidget {
  const CardBack({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return AspectRatio(
      aspectRatio: CardMetrics.aspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CardMetrics.radius),
          border: Border.all(
            color: palette.starGlow,
            width: CardMetrics.borderWidth,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [palette.rarityEpic, palette.nebula, palette.candy],
          ),
          boxShadow: [
            BoxShadow(
              color: palette.rarityEpic.withValues(alpha: 0.5),
              blurRadius: 18,
              offset: const Offset(3, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.auto_awesome,
            size: 64,
            color: palette.starGlow.withValues(alpha: 0.9),
          ),
        ),
      ),
    );
  }
}
