import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/skeleton_box.dart';
import '../../../../technical/Theme/widgets/state_message.dart';
import '../../../Anime/presentation/anime_genre_label.dart';
import '../cubit/recommendations_cubit.dart';
import '../cubit/recommendations_state.dart';
import 'recommendation_tile.dart';

class RecommendationsSection extends StatelessWidget {
  const RecommendationsSection({required this.onAnimeSelected, super.key});

  final void Function(int animeId, String title) onAnimeSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<RecommendationsCubit>();

    return BlocBuilder<RecommendationsCubit, RecommendationsState>(
      builder: (context, state) {
        final genres = [
          for (final genre in state.recommendations.basedOn)
            genreLabel(l10n, genre),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.recoTitle, style: theme.textTheme.titleLarge),
            if (genres.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                genres.length == 1
                    ? l10n.recoBecauseOne(genres.first)
                    : l10n.recoBecauseTwo(genres.first, genres.last),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            switch (state.status) {
              RecommendationsStatus.loading => const _RecommendationsSkeleton(),
              RecommendationsStatus.empty => StateMessage(
                  icon: Icons.auto_awesome_outlined,
                  title: l10n.recoEmpty,
                  description: l10n.recoEmptyHint,
                ),
              RecommendationsStatus.failure => StateMessage(
                  icon: Icons.cloud_off_outlined,
                  title: l10n.recoErrorTitle,
                  description: l10n.serviceUnavailable,
                  actionLabel: l10n.retry,
                  onAction: cubit.load,
                ),
              RecommendationsStatus.success => SizedBox(
                  height: RecommendationTile.posterHeight + 72,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.recommendations.animes.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final anime = state.recommendations.animes[index];

                      return RecommendationTile(
                        key: ValueKey(anime.id),
                        anime: anime,
                        onTap: () => onAnimeSelected(anime.id, anime.title),
                        onAdd: () => cubit.add(anime),
                      );
                    },
                  ),
                ),
            },
          ],
        );
      },
    );
  }
}

class _RecommendationsSkeleton extends StatelessWidget {
  const _RecommendationsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: RecommendationTile.posterHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, _) => const SkeletonBox(
          width: RecommendationTile.width,
          height: RecommendationTile.posterHeight,
          radius: AppSpacing.radiusMd,
        ),
      ),
    );
  }
}
