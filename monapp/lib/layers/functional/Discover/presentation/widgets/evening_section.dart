import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/state_message.dart';
import '../cubit/evening_cubit.dart';
import '../cubit/evening_state.dart';
import 'evening_filters.dart';
import 'evening_suggestion_card.dart';

class EveningSection extends StatelessWidget {
  const EveningSection({required this.onAnimeSelected, super.key});

  final void Function(int animeId, String title) onAnimeSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<EveningCubit>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: BlocBuilder<EveningCubit, EveningState>(
          builder: (context, state) {
            final suggestion = state.suggestion;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.eveningTitle, style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.md),
                EveningFilters(
                  mood: state.mood,
                  duration: state.duration,
                  onMoodSelected: cubit.selectMood,
                  onDurationSelected: cubit.selectDuration,
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.icon(
                  onPressed: state.status == EveningStatus.loading
                      ? null
                      : cubit.suggest,
                  icon: const Icon(Icons.casino_outlined),
                  label: Text(l10n.eveningSuggestAction),
                ),
                const SizedBox(height: AppSpacing.md),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  alignment: Alignment.topCenter,
                  child: switch (state.status) {
                    EveningStatus.idle || EveningStatus.loading =>
                      const SizedBox.shrink(),
                    EveningStatus.none => StateMessage(
                        icon: Icons.search_off,
                        title: l10n.eveningNone,
                        description: l10n.eveningNoneHint,
                      ),
                    EveningStatus.failure => StateMessage(
                        icon: Icons.cloud_off_outlined,
                        title: l10n.eveningErrorTitle,
                        description: l10n.serviceUnavailable,
                        actionLabel: l10n.retry,
                        onAction: cubit.suggest,
                      ),
                    EveningStatus.suggested => EveningSuggestionCard(
                        suggestion: suggestion!,
                        onOpen: () => onAnimeSelected(
                          suggestion.anime.id,
                          suggestion.anime.title,
                        ),
                        onAnother: cubit.suggestAnother,
                      ),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
