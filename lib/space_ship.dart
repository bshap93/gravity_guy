import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gravity_guy/main.dart';

class SpaceShip extends SpriteAnimationComponent
    with HasGameRef<GravityGuyGame>, CollisionCallbacks {
  Vector2 initialPosition = Vector2(500, 775);
  Vector2 textureSize = Vector2(32, 32);
  double lengthAcross = 75;

  bool isFlying = false;

  SpaceShip()
      : super(
            // size: ,
            anchor: Anchor.center,
            angle: pi);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
        'spaceShip1.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: textureSize,
        ));
    // For now the spaceship is represented as a square
    size = Vector2(lengthAcross, lengthAcross);

    position = initialPosition;
    playing = false;
    add(RectangleHitbox(
      size: Vector2(width, height),
      position: Vector2(0, 0),
      anchor: Anchor.center,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isFlying) {
      playing = true;
    } else {
      playing = false;
    }
  }
}
