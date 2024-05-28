import 'package:flame/components.dart';

import '../../../game_parts/outer_space_game_part.dart';

class HomeDome extends PositionComponent with HasGameRef<OuterSpaceGamePart> {
  @override
  void onLoad() async {
    super.onLoad();
    priority = 2;
    add(SpriteComponent(
      size: Vector2(209, 104),
      position: Vector2(0, -215),
      sprite: await Sprite.load('home_dome.png'),
      anchor: Anchor.bottomCenter,
    ));
  }
}
