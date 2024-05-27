import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import '../../../game_parts/outer_space_game_part.dart';

class Planet extends PositionComponent
    with CollisionCallbacks, HasGameRef<OuterSpaceGamePart> {
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

  double angleVelocity = 0.0;

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

  void startSpinning() {
    angle = 0;
    angleVelocity = 0.1;
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle += angleVelocity * dt;
  }
}
