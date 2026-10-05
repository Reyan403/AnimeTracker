import 'package:flutter/material.dart';

import '../../../../technical/Theme/widgets/plaque_row_skeleton.dart';
import '../../../../technical/Theme/widgets/responsive_card_sliver.dart';
import '../../../../technical/Theme/widgets/sliver_content_padding.dart';
import '../../../../technical/Theme/widgets/staggered_appear.dart';
import '../../domain/entities/anime.dart';
import '../../domain/entities/watch_status.dart';
import '../cubit/watchlist_state.dart';
import 'anime_card.dart';
import 'watchlist_empty.dart';
import 'watchlist_error.dart';

class WatchlistResultsSliver extends StatelessWidget {
  const WatchlistResultsSliver({
    required this.state,
    required this.onRetry,
    required this.onAnimeSelected,
    required this.onStatusChanged,
    required this.onNextEpisode,
    required this.onPreviousEpisode,
    super.key,
  });

  final WatchlistState state;
  final VoidCallback onRetry;
  final void Function(int animeId, String title) onAnimeSelected;
  final void Function(int animeId, WatchStatus status) onStatusChanged;
  final ValueChanged<Anime> onNextEpisode;
  final ValueChanged<Anime> onPreviousEpisode;

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      ViewStatus.loading => const SliverContentPadding(
          sliver: SliverToBoxAdapter(child: PlaqueRowSkeleton()),
        ),
      ViewStatus.failure => SliverToBoxAdapter(
          child: WatchlistError(onRetry: onRetry),
        ),
      ViewStatus.empty => const SliverToBoxAdapter(child: WatchlistEmpty()),
      ViewStatus.success => SliverContentPadding(
          bottom: 32,
          sliver: ResponsiveCardSliver(
            itemCount: state.visibleAnimes.length,
            itemBuilder: (context, index) {
              final anime = state.visibleAnimes[index];

              return StaggeredAppear(
                key: ValueKey(anime.id),
                index: index,
                child: AnimeCard(
                  anime: anime,
                  onTap: () => onAnimeSelected(anime.id, anime.title),
                  onStatusSelected: (status) =>
                      onStatusChanged(anime.id, status),
                  onNextEpisode: () => onNextEpisode(anime),
                  onPreviousEpisode: () => onPreviousEpisode(anime),
                ),
              );
            },
          ),
        ),
    };
  }
}
