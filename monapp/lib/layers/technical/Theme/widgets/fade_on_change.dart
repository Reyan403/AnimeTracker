import 'package:flutter/material.dart';

import '../app_motion.dart';

class FadeOnChange extends StatefulWidget {
  const FadeOnChange({required this.trigger, required this.child, super.key});

  final Object trigger;
  final Widget child;

  @override
  State<FadeOnChange> createState() => _FadeOnChangeState();
}

class _FadeOnChangeState extends State<FadeOnChange>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.standard,
    value: 1,
  );

  @override
  void didUpdateWidget(FadeOnChange oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.trigger != widget.trigger &&
        !MediaQuery.disableAnimationsOf(context)) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: AppMotion.curve),
      child: widget.child,
    );
  }
}
