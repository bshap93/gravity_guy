import 'package:flame/components.dart';
import 'package:gravity_guy/main.dart';

enum SpriteOrientedDirection { left, right }

class Astronaut extends SpriteAnimationComponent
    with HasGameRef<GravityGuyGame>, KeyboardHandler {
  Astronaut()
      : super(
          size: Vector2(50, 50),
          anchor: Anchor.center,
        );

  bool isWalking = false;

  SpriteOrientedDirection orientedDirection = SpriteOrientedDirection.right;

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

    // if (walkDirection == WalkDirection.left) {
    //
    // }
  }
}
