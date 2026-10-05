import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/widgets/state_message.dart';
import '../cubit/dex_cubit.dart';

class DexFailureMessage extends StatelessWidget {
  const DexFailureMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StateMessage(
      icon: Icons.cloud_off_outlined,
      title: l10n.dexErrorTitle,
      description: l10n.dexErrorHint,
      actionLabel: l10n.retry,
      onAction: context.read<DexCubit>().load,
    );
  }
}
