import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../cubit/dex_cubit.dart';
import '../cubit/dex_state.dart';
import 'collection_summary.dart';
import 'dex_search_field.dart';
import 'dex_sort_menu.dart';
import 'rarity_filter_bar.dart';

class CollectionControls extends StatelessWidget {
  const CollectionControls({
    required this.state,
    required this.visibleCount,
    super.key,
  });

  final DexState state;
  final int visibleCount;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DexCubit>();
    final l10n = AppLocalizations.of(context);
    final filter = state.filter;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CollectionSummary(state: state),
        const SizedBox(height: AppSpacing.xl),
        DexSearchField(query: filter.query, onChanged: cubit.search),
        const SizedBox(height: AppSpacing.lg),
        RarityFilterBar(
          selected: filter.rarity,
          onSelected: cubit.selectRarity,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.dexCharacterCount(visibleCount),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            DexSortMenu(sort: filter.sort, onSelected: cubit.selectSort),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
