import 'package:flutter/material.dart';

import '../app_palette.dart';

class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    required this.height,
    this.width,
    this.radius = 8,
    super.key,
  });

  final double height;
  final double? width;
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(-1 + 3 * _controller.value, 0),
            end: Alignment(3 * _controller.value, 0),
            colors: [
              palette.skeletonBase,
              palette.skeletonHighlight,
              palette.skeletonBase,
            ],
          ),
        ),
      ),
    );
  }
}
