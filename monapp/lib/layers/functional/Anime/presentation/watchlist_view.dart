import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../technical/Injection/injection.dart';
import '../../../technical/Theme/app_spacing.dart';
import '../../../technical/Theme/widgets/plaque_row_skeleton.dart';
import 'cubit/watchlist_cubit.dart';
import 'cubit/watchlist_state.dart';
import 'widgets/anime_row.dart';
import 'widgets/watch_status_tabs.dart';
import 'widgets/watchlist_empty.dart';
import 'widgets/watchlist_error.dart';
import 'widgets/watchlist_header.dart';

class WatchlistView extends StatelessWidget {
  const WatchlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WatchlistCubit>()..load(),
      child: const WatchlistScaffold(),
    );
  }
}

class WatchlistScaffold extends StatelessWidget {
  const WatchlistScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WatchlistCubit>();

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<WatchlistCubit, WatchlistState>(
          builder: (context, state) => ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            children: [
              WatchlistHeader(state: state),
              const SizedBox(height: AppSpacing.lg),
              WatchStatusTabs(
                state: state,
                onSelected: cubit.selectStatus,
              ),
              const SizedBox(height: AppSpacing.xl),
              switch (state.status) {
                ViewStatus.loading => const PlaqueRowSkeleton(),
                ViewStatus.failure => WatchlistError(onRetry: cubit.load),
                ViewStatus.empty => const WatchlistEmpty(),
                ViewStatus.success => Column(
                    children: [
                      for (final anime in state.visibleAnimes)
                        AnimeRow(anime: anime),
                    ],
                  ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
