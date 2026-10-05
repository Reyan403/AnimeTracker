import 'package:flutter/material.dart';

import '../app_spacing.dart';

class StateMessage extends StatelessWidget {
  const StateMessage({
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final detail = description;
    final label = actionLabel;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
        horizontal: AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Icon(icon, size: 40, color: scheme.onPrimaryContainer),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (detail != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              detail,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (label != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.lg),
            FilledButton.tonal(onPressed: onAction, child: Text(label)),
          ],
        ],
      ),
    );
  }
}
