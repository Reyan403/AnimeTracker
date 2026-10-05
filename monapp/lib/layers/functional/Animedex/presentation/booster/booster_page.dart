import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Injection/injection.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../cubit/booster_cubit.dart';
import '../cubit/booster_state.dart';
import 'booster_body.dart';

class BoosterPage extends StatelessWidget {
  const BoosterPage({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => const BoosterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BoosterCubit>(),
      child: const BoosterScaffold(),
    );
  }
}

class BoosterScaffold extends StatelessWidget {
  const BoosterScaffold({this.now = DateTime.now, super.key});

  final DateTime Function() now;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final cubit = context.read<BoosterCubit>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: palette.nebula,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.3),
            radius: 1.1,
            colors: [
              palette.rarityEpic.withValues(alpha: 0.45),
              palette.nebula,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              BlocBuilder<BoosterCubit, BoosterState>(
                builder: (context, state) => BoosterBody(
                  state: state,
                  now: now,
                  onOpen: cubit.open,
                  onReveal: cubit.reveal,
                  onReset: cubit.reset,
                  onClose: () => Navigator.of(context).maybePop(),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  tooltip: l10n.dexClose,
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    foregroundColor: palette.starGlow,
                    side: BorderSide(color: palette.starGlow, width: 2),
                  ),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
