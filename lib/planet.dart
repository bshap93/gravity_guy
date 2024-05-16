import 'dart:ui';

import 'package:flame/components.dart';
import 'package:gravity_guy/body_with_mass.dart';

class Planet extends BodyWithMass {
  Planet({required this.radius, required this.mass, required this.offset})
      : super(
          anchor: Anchor.center,
          mass: mass,
          acceleration: Vector2(0, 0),
          velocity: Vector2(0, 0),
        );
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
