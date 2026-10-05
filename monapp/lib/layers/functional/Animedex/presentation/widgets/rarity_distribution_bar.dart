import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/card_rarity.dart';
import '../card/rarity_style.dart';
import '../cubit/dex_state.dart';

class RarityDistributionBar extends StatelessWidget {
  const RarityDistributionBar({required this.state, super.key});

  static const double height = 14;

  final DexState state;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: palette.ink, width: 2.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm - 2.5),
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              for (final rarity in CardRarity.values)
                if (state.countOf(rarity) > 0)
                  Expanded(
                    flex: state.countOf(rarity),
                    child: ColoredBox(
                      color: rarity.color(palette),
                      child: const SizedBox.expand(),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
