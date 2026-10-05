import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/dex_card.dart';
import '../cubit/dex_cubit.dart';
import '../cubit/dex_state.dart';
import '../detail/dex_card_dialog.dart';
import 'booster_banner.dart';
import 'booster_launcher.dart';
import 'dex_failure_message.dart';
import 'dex_grid.dart';
import 'dex_skeleton_grid.dart';

class BoosterTab extends StatelessWidget {
  const BoosterTab({required this.state, this.now = DateTime.now, super.key});

  final DexState state;
  final DateTime Function() now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final availability = state.availability;
    final latest = state.status == DexStatus.success
        ? state.latestCards
        : const <DexCard>[];

    return SliverMainAxisGroup(
      slivers: [
        if (availability != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: BoosterBanner(
                availability: availability,
                now: now,
                onOpen: () => BoosterLauncher.open(context),
                onElapsed: context.read<DexCubit>().load,
              ),
            ),
          ),
        if (state.status == DexStatus.failure)
          const SliverToBoxAdapter(child: DexFailureMessage()),
        if (state.status == DexStatus.loading) const DexSkeletonGrid(),
        if (latest.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                l10n.dexLatestCardsTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          DexGrid(
            cards: latest,
            onCardTap: (card) => DexCardDialog.show(context, card),
          ),
        ],
      ],
    );
  }
}
