import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../technical/Injection/injection.dart';
import '../../../technical/Theme/app_spacing.dart';
import '../../../technical/Theme/widgets/sliver_content_padding.dart';
import 'cubit/agenda_cubit.dart';
import 'cubit/agenda_state.dart';
import 'widgets/agenda_filter.dart';
import 'widgets/agenda_results_sliver.dart';

typedef AgendaAnimeSelected = void Function(int animeId, String title);

class AgendaView extends StatelessWidget {
  const AgendaView({required this.onAnimeSelected, super.key});

  final AgendaAnimeSelected onAnimeSelected;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AgendaCubit>()..load(),
      child: AgendaScaffold(onAnimeSelected: onAnimeSelected),
    );
  }
}

class AgendaScaffold extends StatelessWidget {
  const AgendaScaffold({required this.onAnimeSelected, super.key});

  final AgendaAnimeSelected onAnimeSelected;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AgendaCubit>();

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AgendaCubit, AgendaState>(
          builder: (context, state) => CustomScrollView(
            slivers: [
              SliverContentPadding(
                top: AppSpacing.lg,
                bottom: AppSpacing.lg,
                sliver: SliverToBoxAdapter(
                  child: Text(
                    AppLocalizations.of(context).agendaTitle,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
              SliverContentPadding(
                bottom: AppSpacing.md,
                sliver: SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AgendaFilter(
                      onlyWatchlist: state.onlyWatchlist,
                      onChanged: (onlyWatchlist) =>
                          cubit.selectFilter(onlyWatchlist: onlyWatchlist),
                    ),
                  ),
                ),
              ),
              AgendaResultsSliver(
                state: state,
                now: DateTime.now(),
                onRetry: cubit.load,
                onAnimeSelected: onAnimeSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
