import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:gravity_guy/astronaut.dart';
import 'package:gravity_guy/body_with_mass.dart';
import 'package:gravity_guy/main.dart';

class Planet extends PositionComponent
    with BodyWithMass, CollisionCallbacks, HasGameRef<GravityGuyGame> {
  Planet({
    required this.radius,
    required this.mass,
    required this.offset,
    required Vector2 positionVector,
  }) : super(
          anchor: Anchor.center,
          position: Vector2(positionVector.x, positionVector.y),
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

  @override
  Future<void> onLoad() async {
    add(SpriteComponent(
        sprite: Sprite(await Flame.images.load('planet1.png')),
        anchor: Anchor.center,
        size: Vector2(radius * 3.25, radius * 3.25)));
    add(CircleHitbox(
      radius: radius,
      anchor: Anchor.center,
      position: Vector2(offset.dx, offset.dy),
    ));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Astronaut) {
      //
    }
  }
}
