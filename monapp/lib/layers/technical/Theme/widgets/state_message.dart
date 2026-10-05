import 'package:flutter/material.dart';

import '../app_motion.dart';
import '../app_palette.dart';
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
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: AppMotion.resolve(
              context,
              const Duration(milliseconds: 600),
            ),
            curve: Curves.elasticOut,
            builder: (context, progress, child) => Transform.scale(
              scale: progress,
              child: Transform.rotate(
                angle: -0.12 * (1 - progress),
                child: child,
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppPalette.of(context).sun,
                shape: BoxShape.circle,
                border: Border.all(color: AppPalette.of(context).ink, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.of(context).hardShadow,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Icon(icon, size: 40, color: const Color(0xFF1B1535)),
              ),
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
