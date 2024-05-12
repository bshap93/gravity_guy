import 'dart:ui';

import 'package:flame/components.dart';

class Planet extends PositionComponent {
  Planet({required this.radius, required this.mass, required this.offset});
  double radius;
  double mass;
  Offset offset;
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      offset,
      radius,
      Paint()..color = const Color(0xFF0000FF),
    );
  }
}
