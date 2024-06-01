import 'package:flame/components.dart';

import '../../../game_parts/outer_space_game_part.dart';

class HomeDome extends PositionComponent with HasGameRef<OuterSpaceGamePart> {
  HomeDome({required Vector2 initialPosition})
      : super(
          anchor: Anchor.center,
          position: Vector2(initialPosition.x, initialPosition.y),
        );
  @override
  void onLoad() async {
    super.onLoad();
    position = Vector2(0, -310);
    priority = 2;
    add(SpriteComponent(
      size: Vector2(209, 104),
      sprite: await Sprite.load('home_dome.png'),
      anchor: Anchor.bottomCenter,
    ));
  }
}
