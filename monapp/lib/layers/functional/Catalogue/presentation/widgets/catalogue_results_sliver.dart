import 'package:flutter/material.dart';

import '../../../../technical/Theme/widgets/plaque_row_skeleton.dart';
import '../../../../technical/Theme/widgets/responsive_card_sliver.dart';
import '../../../../technical/Theme/widgets/sliver_content_padding.dart';
import '../../../../technical/Theme/widgets/staggered_appear.dart';
import '../../domain/entities/catalogue_anime.dart';
import '../cubit/catalogue_state.dart';
import 'catalogue_card.dart';
import 'catalogue_empty.dart';
import 'catalogue_error.dart';

class CatalogueResultsSliver extends StatelessWidget {
  const CatalogueResultsSliver({
    required this.state,
    required this.onRetry,
    required this.onAnimeSelected,
    required this.onAdd,
    super.key,
  });

  final CatalogueState state;
  final VoidCallback onRetry;
  final ValueChanged<CatalogueAnime> onAnimeSelected;
  final ValueChanged<CatalogueAnime> onAdd;

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      CatalogueStatus.loading => const SliverContentPadding(
          sliver: SliverToBoxAdapter(child: PlaqueRowSkeleton()),
        ),
      CatalogueStatus.failure => SliverToBoxAdapter(
          child: CatalogueError(onRetry: onRetry),
        ),
      CatalogueStatus.empty => SliverToBoxAdapter(
          child: CatalogueEmpty(isSearching: state.isSearching),
        ),
      CatalogueStatus.success => SliverContentPadding(
          sliver: ResponsiveCardSliver(
            itemCount: state.animes.length,
            itemBuilder: (context, index) {
              final anime = state.animes[index];

              return StaggeredAppear(
                key: ValueKey(anime.id),
                index: index,
                child: CatalogueCard(
                  anime: anime,
                  isListed: state.isListed(anime),
                  onTap: () => onAnimeSelected(anime),
                  onAdd: () => onAdd(anime),
                ),
              );
            },
          ),
        ),
    };
  }
}
