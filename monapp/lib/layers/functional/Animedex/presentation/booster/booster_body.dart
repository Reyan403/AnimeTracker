import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_motion.dart';
import '../../domain/use_cases/booster_day.dart';
import '../cubit/booster_state.dart';
import 'booster_message_panel.dart';
import 'pack_stage.dart';
import 'reveal_stage.dart';

class BoosterBody extends StatelessWidget {
  const BoosterBody({
    required this.state,
    required this.now,
    required this.onOpen,
    required this.onReveal,
    required this.onReset,
    required this.onClose,
    super.key,
  });

  final BoosterState state;
  final DateTime Function() now;
  final VoidCallback onOpen;
  final VoidCallback onReveal;
  final VoidCallback onReset;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final stage = switch (state.status) {
      BoosterStatus.idle || BoosterStatus.opening => PackStage(
        key: const ValueKey('pack'),
        isOpening: state.status == BoosterStatus.opening,
        onOpen: onOpen,
      ),
      BoosterStatus.revealed => RevealStage(
        key: const ValueKey('reveal'),
        state: state,
        onReveal: onReveal,
        onDone: onClose,
      ),
      BoosterStatus.alreadyOpened => AlreadyOpenedPanel(
        key: const ValueKey('already'),
        nextAt: BoosterDay.midnightAfter(now()),
        now: now,
        onElapsed: onReset,
        onDone: onClose,
      ),
      BoosterStatus.failure => BoosterFailurePanel(
        key: const ValueKey('failure'),
        onRetry: onOpen,
        onClose: onClose,
      ),
    };

    return AnimatedSwitcher(
      duration: AppMotion.resolve(context, AppMotion.standard),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1).animate(animation),
          child: child,
        ),
      ),
      child: stage,
    );
  }
}
