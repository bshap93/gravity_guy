import 'package:flame/components.dart';

import '../../../../game_parts/outer_space_game_part.dart';

class DomeComponent extends PositionComponent
    with HasGameRef<OuterSpaceGamePart> {
  DomeComponent({required Vector2 initialPosition})
      : super(anchor: Anchor.center, position: initialPosition);
  @override
  void onLoad() async {
    super.onLoad();
    priority = 2;
    add(SpriteComponent(
      size: Vector2(209, 104),
      sprite: await Sprite.load('home_dome.png'),
      anchor: Anchor.bottomCenter,
    ));
  }
}
