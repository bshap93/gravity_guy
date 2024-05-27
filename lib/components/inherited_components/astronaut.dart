import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:gravity_guy/components/outer_space_game_part/controllable_components/astronaut_outdoor_character_part.dart';

import 'game_part.dart';

class Astronaut extends SpriteAnimationComponent
    with HasGameRef<GamePart>, KeyboardHandler, CollisionCallbacks {
  bool isWalking = false;
  SpriteOrientedDirection orientedDirection = SpriteOrientedDirection.right;
  Vector2 velocity = Vector2.zero();
  double hitBoxRadius;

  late SpriteSheet spriteSheet;
  late SpriteAnimation stationaryAnimation;

  Astronaut({this.hitBoxRadius = 50})
      : super(
          size: Vector2(50, 50),
          anchor: Anchor.center,
          angle: 0,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    spriteSheet = SpriteSheet(
      image: await gameRef.images.load('astronaut4.png'),
      srcSize: Vector2(32, 32),
    );

    stationaryAnimation = SpriteAnimation.fromFrameData(
        spriteSheet.image,
        SpriteAnimationData([
          spriteSheet.createFrameData(0, 0, stepTime: 0.3),
          spriteSheet.createFrameData(0, 1, stepTime: 0.3),
          spriteSheet.createFrameData(0, 2, stepTime: 0.3),
        ]));

    animation = stationaryAnimation;
    playing = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }
}
