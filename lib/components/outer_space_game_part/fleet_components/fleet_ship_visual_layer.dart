import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../../../game_parts/outer_space_game_part.dart';
import '../controllable_components/space_ship/shield.dart';

class FleetShipVisualLayer extends SpriteAnimationComponent
    with HasGameRef<OuterSpaceGamePart> {
  Vector2 textureSize;
  Vector2 parentSize;
  int parentPriority;
  int bobAmount;
  late Shield shield;

  FleetShipVisualLayer({
    required this.textureSize,
    required this.parentSize,
    required this.parentPriority,
    this.bobAmount = 10,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = parentSize;
    priority = parentPriority;
    position = Vector2.zero();

    animation = await game.loadSpriteAnimation(
        'space_ships/capital_ship_01.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: textureSize,
        ));

    shield = Shield(
      position: Vector2(width / 2, height / 2),
      ellipseHeight: height,
      ellipseWidth: width,
    );
    add(shield);

    bobInPlace();
  }

  void bobInPlace() {
    final ec = RepeatedEffectController(SineEffectController(period: 2), 5);
    final effect = MoveByEffect(Vector2(0, 10), ec);
    add(effect);
  }
}
