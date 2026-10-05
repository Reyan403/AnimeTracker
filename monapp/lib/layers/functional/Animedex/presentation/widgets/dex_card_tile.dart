import 'package:flutter/material.dart';

import '../../domain/entities/dex_card.dart';
import '../card/holographic_card.dart';

class DexCardTile extends StatelessWidget {
  const DexCardTile({required this.card, required this.onTap, super.key});

  final DexCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: HolographicCard(card: card, compact: true),
      ),
    );
  }
}
