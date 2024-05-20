import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:gravity_guy/main.dart';

class Planet extends PositionComponent
    with CollisionCallbacks, HasGameRef<GravityGuyGame> {
  double spriteScalingFactor = 2.1;
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
        sprite: Sprite(await Flame.images.load('rock_type_planet.png')),
        anchor: Anchor.center,
        size: Vector2(
            radius * spriteScalingFactor, radius * spriteScalingFactor)));
    add(CircleHitbox(
      radius: radius,
      anchor: Anchor.center,
      position: Vector2(offset.dx, offset.dy),
    ));
  }
}
