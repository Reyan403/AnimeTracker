import 'package:flutter/widgets.dart';

class SlideGradientTransform extends GradientTransform {
  const SlideGradientTransform(this.slide);

  final double slide;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * slide, 0, 0);
}
