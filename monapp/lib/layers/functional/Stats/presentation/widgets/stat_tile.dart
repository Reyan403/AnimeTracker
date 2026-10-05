import 'package:flutter/material.dart';

import '../../../../technical/Theme/app_spacing.dart';
import '../../../../technical/Theme/widgets/animated_count.dart';

class StatTile extends StatelessWidget {
  const StatTile({
    required this.value,
    required this.label,
    required this.icon,
    this.format,
    super.key,
  });

  final int value;
  final String label;
  final IconData icon;
  final String Function(int value)? format;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: scheme.primary),
            const SizedBox(height: AppSpacing.sm),
            AnimatedCount(
              value: value,
              builder: (context, current) => Text(
                format?.call(current) ?? '$current',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
