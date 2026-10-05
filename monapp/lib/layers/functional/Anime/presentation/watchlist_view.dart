import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../technical/Injection/injection.dart';
import '../../../technical/Theme/app_spacing.dart';
import '../../../technical/Theme/widgets/offline_notice.dart';
import '../../../technical/Theme/widgets/sliver_content_padding.dart';
import 'cubit/watchlist_cubit.dart';
import 'cubit/watchlist_state.dart';
import 'widgets/watch_status_tabs.dart';
import 'widgets/watchlist_header.dart';
import 'widgets/watchlist_results_sliver.dart';

typedef AnimeSelected = void Function(int animeId, String title);

class WatchlistView extends StatelessWidget {
  const WatchlistView({required this.onAnimeSelected, super.key});

  final AnimeSelected onAnimeSelected;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WatchlistCubit>()..load(),
      child: WatchlistScaffold(onAnimeSelected: onAnimeSelected),
    );
  }
}

class WatchlistScaffold extends StatelessWidget {
  const WatchlistScaffold({required this.onAnimeSelected, super.key});

  final AnimeSelected onAnimeSelected;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WatchlistCubit>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocBuilder<WatchlistCubit, WatchlistState>(
          builder: (context, state) => CustomScrollView(
            slivers: [
              SliverContentPadding(
                top: AppSpacing.lg,
                bottom: AppSpacing.lg,
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WatchlistHeader(),
                      const SizedBox(height: AppSpacing.lg),
                      WatchStatusTabs(
                        state: state,
                        onSelected: cubit.selectStatus,
                      ),
                      if (state.isShowingCache) ...[
                        const SizedBox(height: AppSpacing.md),
                        const OfflineNotice(),
                      ],
                    ],
                  ),
                ),
              ),
              WatchlistResultsSliver(
                state: state,
                onRetry: cubit.load,
                onAnimeSelected: onAnimeSelected,
                onStatusChanged: cubit.changeStatus,
                onNextEpisode: cubit.watchNextEpisode,
                onPreviousEpisode: cubit.watchPreviousEpisode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
