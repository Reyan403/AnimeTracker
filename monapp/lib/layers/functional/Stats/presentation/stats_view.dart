import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../technical/Injection/injection.dart';
import '../../../technical/Theme/app_spacing.dart';
import '../../../technical/Theme/widgets/sliver_content_padding.dart';
import '../../Settings/presentation/cubit/settings_cubit.dart';
import '../../Settings/presentation/widgets/spoiler_guard_switch.dart';
import 'cubit/stats_cubit.dart';
import 'cubit/stats_state.dart';
import 'widgets/stats_content.dart';

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<StatsCubit>()..load()),
        BlocProvider(create: (_) => getIt<SettingsCubit>()),
      ],
      child: const StatsScaffold(),
    );
  }
}

class StatsScaffold extends StatelessWidget {
  const StatsScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StatsCubit>();

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<StatsCubit, StatsState>(
          builder: (context, state) => CustomScrollView(
            slivers: [
              SliverContentPadding(
                top: AppSpacing.lg,
                bottom: AppSpacing.lg,
                sliver: SliverToBoxAdapter(
                  child: Text(
                    AppLocalizations.of(context).statsTitle,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
              SliverContentPadding(
                bottom: AppSpacing.xl,
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      StatsContent(state: state, onRetry: cubit.load),
                      const SizedBox(height: AppSpacing.xl),
                      const SpoilerGuardSwitch(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
