import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../technical/Injection/injection.dart';
import '../../../technical/Theme/app_spacing.dart';
import '../../../technical/Theme/widgets/plaque_row_skeleton.dart';
import 'cubit/catalogue_cubit.dart';
import 'cubit/catalogue_state.dart';
import 'widgets/catalogue_empty.dart';
import 'widgets/catalogue_error.dart';
import 'widgets/catalogue_row.dart';
import 'widgets/catalogue_search_field.dart';

class CatalogueView extends StatelessWidget {
  const CatalogueView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CatalogueCubit>()..load(),
      child: const CatalogueScaffold(),
    );
  }
}

class CatalogueScaffold extends StatefulWidget {
  const CatalogueScaffold({super.key});

  @override
  State<CatalogueScaffold> createState() => _CatalogueScaffoldState();
}

class _CatalogueScaffoldState extends State<CatalogueScaffold> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    context.read<CatalogueCubit>().clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<CatalogueCubit>();

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CatalogueCubit, CatalogueState>(
          builder: (context, state) => ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            children: [
              Text('Catalogue', style: theme.textTheme.displaySmall),
              const SizedBox(height: AppSpacing.lg),
              CatalogueSearchField(
                controller: _controller,
                onChanged: cubit.search,
                onCleared: _clear,
              ),
              const SizedBox(height: AppSpacing.xl),
              switch (state.status) {
                CatalogueStatus.loading => const PlaqueRowSkeleton(),
                CatalogueStatus.failure => CatalogueError(onRetry: cubit.load),
                CatalogueStatus.empty =>
                  CatalogueEmpty(isSearching: state.isSearching),
                CatalogueStatus.success => Column(
                    children: [
                      for (final anime in state.animes)
                        CatalogueRow(anime: anime),
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
