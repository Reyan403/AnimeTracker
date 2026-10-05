import 'package:flutter/material.dart';

import '../../domain/entities/drawn_card.dart';
import '../card/card_metrics.dart';
import '../card/holographic_card.dart';
import 'card_back.dart';
import 'drawn_badge.dart';
import 'flip_reveal.dart';

class RevealCard extends StatelessWidget {
  const RevealCard({
    required this.revealedCount,
    required this.current,
    required this.onReveal,
    super.key,
  });

  final int revealedCount;
  final DrawnCard? current;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    final drawn = current;

    return LayoutBuilder(
      builder: (context, box) {
        final width = (box.maxHeight * CardMetrics.aspectRatio).clamp(
          0.0,
          box.maxWidth * 0.82,
        );

        return Center(
          child: SizedBox(
            width: width.toDouble(),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onReveal,
              child: drawn == null
                  ? const CardBack()
                  : FlipReveal(
                      key: ValueKey(revealedCount),
                      back: const CardBack(),
                      front: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          HolographicCard(card: drawn.card, isLive: true),
                          Positioned(
                            top: -10,
                            right: -10,
                            child: DrawnBadge(isNew: drawn.isNew),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
