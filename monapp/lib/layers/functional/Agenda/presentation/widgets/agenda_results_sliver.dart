import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/widgets/plaque_row_skeleton.dart';
import '../../../../technical/Theme/widgets/responsive_card_sliver.dart';
import '../../../../technical/Theme/widgets/sliver_content_padding.dart';
import '../../../../technical/Theme/widgets/staggered_appear.dart';
import '../../../../technical/Theme/widgets/state_message.dart';
import '../cubit/agenda_state.dart';
import 'release_card.dart';

class AgendaResultsSliver extends StatelessWidget {
  const AgendaResultsSliver({
    required this.state,
    required this.now,
    required this.onRetry,
    required this.onAnimeSelected,
    super.key,
  });

  final AgendaState state;
  final DateTime now;
  final VoidCallback onRetry;
  final void Function(int animeId, String title) onAnimeSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final releases = state.releases;

    return switch (state.status) {
      AgendaStatus.loading => const SliverContentPadding(
          sliver: SliverToBoxAdapter(child: PlaqueRowSkeleton(rowCount: 2)),
        ),
      AgendaStatus.failure => SliverToBoxAdapter(
          child: StateMessage(
            icon: Icons.cloud_off_outlined,
            title: l10n.agendaErrorTitle,
            description: l10n.serviceUnavailable,
            actionLabel: l10n.retry,
            onAction: onRetry,
          ),
        ),
      AgendaStatus.empty => SliverToBoxAdapter(
          child: StateMessage(
            icon: Icons.event_busy_outlined,
            title: l10n.agendaEmpty,
            description: l10n.agendaEmptyHint,
          ),
        ),
      AgendaStatus.success => SliverContentPadding(
          bottom: 32,
          sliver: ResponsiveCardSliver(
            itemCount: releases.length,
            cardHeight: 150,
            itemBuilder: (context, index) {
              final release = releases[index];
              final animeId = release.animeId;

              return StaggeredAppear(
                key: ObjectKey(release),
                index: index,
                child: ReleaseCard(
                  release: release,
                  now: now,
                  onTap: animeId == null
                      ? null
                      : () => onAnimeSelected(animeId, release.title),
                ),
              );
            },
          ),
        ),
    };
  }
}
