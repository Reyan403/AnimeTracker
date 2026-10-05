import 'package:flutter/widgets.dart';

class TiltSurface extends StatelessWidget {
  const TiltSurface({
    required this.onTilt,
    required this.onHoverChanged,
    required this.enableTouch,
    required this.child,
    super.key,
  });

  final ValueChanged<Offset> onTilt;
  final ValueChanged<bool> onHoverChanged;
  final bool enableTouch;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        Offset normalize(Offset point) => Offset(
          ((point.dx / box.maxWidth) * 2 - 1).clamp(-1.0, 1.0).toDouble(),
          ((point.dy / box.maxHeight) * 2 - 1).clamp(-1.0, 1.0).toDouble(),
        );

        final surface = MouseRegion(
          onEnter: (_) => onHoverChanged(true),
          onExit: (_) {
            onHoverChanged(false);
            onTilt(Offset.zero);
          },
          onHover: (event) => onTilt(normalize(event.localPosition)),
          child: child,
        );

        if (!enableTouch) {
          return surface;
        }

        return GestureDetector(
          onPanDown: (details) => onTilt(normalize(details.localPosition)),
          onPanUpdate: (details) => onTilt(normalize(details.localPosition)),
          onPanEnd: (_) => onTilt(Offset.zero),
          onPanCancel: () => onTilt(Offset.zero),
          child: surface,
        );
      },
    );
  }
}
