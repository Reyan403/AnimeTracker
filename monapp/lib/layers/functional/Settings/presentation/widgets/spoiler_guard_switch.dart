import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/pop_card.dart';
import '../cubit/settings_cubit.dart';

class SpoilerGuardSwitch extends StatelessWidget {
  const SpoilerGuardSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        PopCard(
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) => SwitchListTile(
              value: state.isSpoilerGuardEnabled,
              onChanged: (enabled) => context
                  .read<SettingsCubit>()
                  .changeSpoilerGuard(enabled: enabled),
              title: Text(l10n.spoilerGuardTitle),
              subtitle: Text(l10n.spoilerGuardSubtitle),
            ),
          ),
        ),
      ],
    );
  }
}
