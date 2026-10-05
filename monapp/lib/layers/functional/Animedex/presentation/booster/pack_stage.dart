import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_palette.dart';
import '../../../../technical/Theme/app_spacing.dart';
import 'sealed_pack.dart';

class PackStage extends StatelessWidget {
  const PackStage({required this.isOpening, required this.onOpen, super.key});

  final bool isOpening;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = AppPalette.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.62,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: SealedPack(isOpening: isOpening, onTap: onOpen),
                ),
              ),
            ),
          ),
          Text(
            isOpening ? l10n.dexPackOpening : l10n.dexPackTapHint,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(color: palette.starGlow),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
