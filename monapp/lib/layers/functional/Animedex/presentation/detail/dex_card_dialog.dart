import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../technical/Theme/app_spacing.dart';
import '../../domain/entities/dex_card.dart';
import '../card/holographic_card.dart';
import 'dex_card_details.dart';

class DexCardDialog extends StatelessWidget {
  const DexCardDialog({required this.card, super.key});

  static const double maxCardWidth = 240;
  static const double maxDialogWidth = 360;

  final DexCard card;

  static Future<void> show(BuildContext context, DexCard card) {
    return showDialog<void>(
      context: context,
      builder: (_) => DexCardDialog(card: card),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxDialogWidth),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: maxCardWidth),
                    child: HolographicCard(card: card, isLive: true),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              DexCardDetails(card: card),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context).dexClose),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
