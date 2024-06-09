import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:gravity_guy/components/outer_space_game_part/environment_components/rocky_moon/home_dome.dart';

import '../../../../game_parts/outer_space_game_part.dart';

class RockyMoon extends PositionComponent
    with CollisionCallbacks, HasGameRef<OuterSpaceGamePart> {
  double spriteScalingFactor = 2.1;
  RockyMoon({
    required this.radius,
    required this.offset,
    required Vector2 positionVector,
  }) : super(
          anchor: Anchor.center,
          position: Vector2(positionVector.x, positionVector.y),
        );
  double radius;
  Offset offset;

  double angleVelocity = 0.0;

  @override
  Future<void> onLoad() async {
    add(
      DomeComponent(
        initialPosition: Vector2(0, -310),
      ), // HomeDome is a component
    );
    add(SpriteComponent(
        sprite: Sprite(await Flame.images.load('Lunar_03-512x512.png')),
        priority: 3,
        anchor: Anchor.center,
        size: Vector2(
            radius * spriteScalingFactor, radius * spriteScalingFactor)));
    add(CircleHitbox(
      radius: radius - 10,
      anchor: Anchor.center,
      position: Vector2(offset.dx, offset.dy),
    ));
  }

  void startSpinning() {
    angle = 0;
    angleVelocity = 0.1;
  }

  void stopSpinning() {
    angleVelocity = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle += angleVelocity * dt;
  }
}
