import 'package:flame/components.dart';
import 'package:gravity_guy/body_with_mass.dart';
import 'package:gravity_guy/main.dart';

enum SpriteOrientedDirection { left, right }

class Astronaut extends BodyWithMass
    with HasGameRef<GravityGuyGame>, KeyboardHandler {
  bool isWalking = false;

  Vector2 accelerationDueToGravity = Vector2(0, 100);
  SpriteOrientedDirection orientedDirection = SpriteOrientedDirection.right;

  // size of astronaut is 50x50

  Astronaut()
      : super(
            mass: 1,
            anchor: Anchor.center,
            velocity: Vector2(0, 0),
            acceleration: Vector2(0, 0));

  changeDirection(SpriteOrientedDirection direction) {
    if (direction == SpriteOrientedDirection.left &&
        orientedDirection == SpriteOrientedDirection.right) {
      orientedDirection = SpriteOrientedDirection.left;
      // flip sprite
      angle = 3.14;
      flipVertically();
    }

    if (direction == SpriteOrientedDirection.right &&
        orientedDirection == SpriteOrientedDirection.left) {
      orientedDirection = SpriteOrientedDirection.right;
      angle = 0;
      flipVertically();
    }
  }

  void jump() {
    velocity = Vector2(0, -100);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
        'astronaut3.png',
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(29, 37),
        ));

    // sprite = await gameRef.loadSprite('astronaut3.png');
    position = Vector2(500, 225);
    playing = false;
    // angle = 0;
    // stop animation
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isWalking) {
      playing = true;
    } else {
      playing = false;
    }

    position += velocity * dt;

    velocity += accelerationDueToGravity * dt;

    // if (walkDirection == WalkDirection.left) {
    //
    // }
  }
}
