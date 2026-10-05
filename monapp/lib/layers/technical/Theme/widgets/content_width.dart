import 'package:flutter/material.dart';

import '../app_spacing.dart';

class ContentWidth extends StatelessWidget {
  const ContentWidth({
    required this.child,
    this.maxWidth = AppSpacing.contentMaxWidth,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
