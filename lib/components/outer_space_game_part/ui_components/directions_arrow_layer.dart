import 'package:flame/components.dart';

import '../../../game_parts/outer_space_game_part.dart';

class DirectionsArrowLayer extends PositionComponent
    with HasGameRef<OuterSpaceGamePart> {
  Vector2 directionArrowAngle = Vector2(0, 0);

  DirectionsArrowLayer() : super();
}
