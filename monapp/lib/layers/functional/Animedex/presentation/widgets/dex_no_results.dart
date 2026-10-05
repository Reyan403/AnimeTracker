import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/widgets/state_message.dart';
import '../cubit/dex_cubit.dart';

class DexNoResults extends StatelessWidget {
  const DexNoResults({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StateMessage(
      icon: Icons.search_off_rounded,
      title: l10n.dexNoResultsTitle,
      description: l10n.dexNoResultsHint,
      actionLabel: l10n.dexResetFilters,
      onAction: context.read<DexCubit>().resetFilters,
    );
  }
}
