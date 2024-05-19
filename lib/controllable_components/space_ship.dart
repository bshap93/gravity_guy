import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gravity_guy/main.dart';
import 'package:gravity_guy/ui_components/interaction_text.dart';

import 'astronaut.dart';

class SpaceShip extends SpriteAnimationComponent
    with HasGameRef<GravityGuyGame>, CollisionCallbacks {
  Vector2 initialPosition = Vector2(500, 775);
  Vector2 textureSize = Vector2(32, 32);
  double lengthAcross = 75;
  bool isTouchedByAstronaut = false;

  bool isFlying = false;

  InteractionText enterSpaceShipText = InteractionText(
      positionVector: Vector2(500, 900), text: 'Press X to enter');

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

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Astronaut) {
      isTouchedByAstronaut = true;
      add(enterSpaceShipText);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Astronaut) {
      remove(enterSpaceShipText);
    }
  }
}
