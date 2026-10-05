import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_motion.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../Discover/domain/entities/evening_mood.dart';
import '../../domain/entities/constellation_star.dart';
import 'star_preview_card.dart';

class StarPreviewPanel extends StatelessWidget {
  const StarPreviewPanel({
    required this.star,
    required this.genres,
    required this.linkCount,
    required this.onOpen,
    required this.onClose,
    super.key,
  });

  final ConstellationStar? star;
  final List<EveningMood> genres;
  final int linkCount;
  final VoidCallback onOpen;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final current = star;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.contentMaxWidth,
            ),
            child: AnimatedSwitcher(
              duration: AppMotion.resolve(context, AppMotion.standard),
              switchInCurve: Curves.easeOutBack,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: current == null
                  ? const SizedBox.shrink(key: ValueKey('no-star'))
                  : StarPreviewCard(
                      key: ValueKey(current.animeId),
                      star: current,
                      genre: genres
                          .where((genre) => genre.name == current.genreSlug)
                          .firstOrNull,
                      linkCount: linkCount,
                      onOpen: onOpen,
                      onClose: onClose,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
