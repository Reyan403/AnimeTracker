import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/pop_card.dart';
import '../../../../technical/Theme/widgets/state_message.dart';
import '../widgets/countdown_text.dart';

class AlreadyOpenedPanel extends StatelessWidget {
  const AlreadyOpenedPanel({
    required this.nextAt,
    required this.now,
    required this.onElapsed,
    required this.onDone,
    super.key,
  });

  final DateTime nextAt;
  final DateTime Function() now;
  final VoidCallback onElapsed;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return PanelFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StateMessage(
            icon: Icons.hourglass_bottom_rounded,
            title: l10n.dexAlreadyOpenedTitle,
            description: l10n.dexAlreadyOpenedHint,
          ),
          CountdownText(
            target: nextAt,
            now: now,
            onElapsed: onElapsed,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppPalette.of(context).accentText,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(onPressed: onDone, child: Text(l10n.dexSeeCards)),
        ],
      ),
    );
  }
}

class BoosterFailurePanel extends StatelessWidget {
  const BoosterFailurePanel({
    required this.onRetry,
    required this.onClose,
    super.key,
  });

  final VoidCallback onRetry;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PanelFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StateMessage(
            icon: Icons.cloud_off_outlined,
            title: l10n.dexBoosterErrorTitle,
            description: l10n.dexBoosterErrorHint,
            actionLabel: l10n.retry,
            onAction: onRetry,
          ),
          TextButton(onPressed: onClose, child: Text(l10n.dexClose)),
        ],
      ),
    );
  }
}

class PanelFrame extends StatelessWidget {
  const PanelFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: PopCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
