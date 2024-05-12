import 'package:flame/components.dart';
import 'package:gravity_guy/main.dart';

class Astronaut extends SpriteAnimationComponent
    with HasGameRef<GravityGuyGame> {
  Astronaut()
      : super(
          size: Vector2(50, 50),
          anchor: Anchor.center,
        );

  bool isWalking = false;

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
    // stop animation
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
