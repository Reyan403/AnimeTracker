import 'package:flutter/material.dart';

import '../app_motion.dart';
import '../app_palette.dart';
import '../app_spacing.dart';

class PopCard extends StatefulWidget {
  const PopCard({
    required this.child,
    this.clipBehavior = Clip.none,
    this.isInteractive = false,
    super.key,
  });

  static const double restingOffset = 4;
  static const double hoverOffset = 7;
  static const double pressedOffset = 1;

  final Widget child;
  final Clip clipBehavior;
  final bool isInteractive;

  @override
  State<PopCard> createState() => _PopCardState();
}

class _PopCardState extends State<PopCard> {
  bool _isPressed = false;
  bool _isHovered = false;

  double get _offset => _isPressed
      ? PopCard.pressedOffset
      : _isHovered
      ? PopCard.hoverOffset
      : PopCard.restingOffset;

  void _setPressed({required bool value}) {
    if (widget.isInteractive && _isPressed != value) {
      setState(() => _isPressed = value);
    }
  }

  void _setHovered({required bool value}) {
    if (widget.isInteractive && _isHovered != value) {
      setState(() => _isHovered = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final shift = PopCard.restingOffset - _offset;

    return MouseRegion(
      onEnter: (_) => _setHovered(value: true),
      onExit: (_) => _setHovered(value: false),
      child: Listener(
        onPointerDown: (_) => _setPressed(value: true),
        onPointerUp: (_) => _setPressed(value: false),
        onPointerCancel: (_) => _setPressed(value: false),
        child: AnimatedContainer(
          duration: AppMotion.resolve(context, AppMotion.fast),
          curve: Curves.easeOutBack,
          transform: Matrix4.translationValues(shift, shift, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            boxShadow: [
              BoxShadow(
                color: palette.hardShadow,
                offset: Offset(_offset, _offset),
              ),
            ],
          ),
          child: Card(clipBehavior: widget.clipBehavior, child: widget.child),
        ),
      ),
    );
  }
}
