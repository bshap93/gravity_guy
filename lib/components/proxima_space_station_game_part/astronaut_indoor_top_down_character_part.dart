import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../inherited_components/astronaut.dart';
import 'map_proxima_space_station.dart';

class AstronautIndoorTopDownCharacterPart extends Astronaut {
  AstronautIndoorTopDownCharacterPart({required this.startingPosition})
      : super(
          hitBoxRadius: 32,
        );

  final Vector2 startingPosition;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = startingPosition;
    // velocity = Vector2(0, 100);
    // velocity = Vector2(-100, 0);
    velocity = Vector2.zero();

    size = Vector2(32, 32);

    add(RectangleHitbox(
      size: Vector2(64, 84),
      position: Vector2(0, 0),
      anchor: Anchor.center,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    // position += velocity * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is MapProximaSpaceStation) {
      velocity = Vector2.zero();
    }
  }

  void walk(WalkingDirection direction) {
    switch (direction) {
      case WalkingDirection.up:
        velocity = Vector2(0, -100);
        break;
      case WalkingDirection.down:
        velocity = Vector2(0, 100);
        break;
      case WalkingDirection.left:
        velocity = Vector2(-100, 0);
        break;
      case WalkingDirection.upLeft:
        velocity = Vector2(-100, -100);
        break;
      case WalkingDirection.upRight:
        velocity = Vector2(100, -100);
        break;
      case WalkingDirection.downLeft:
        velocity = Vector2(-100, 100);
        break;
      case WalkingDirection.downRight:
        velocity = Vector2(100, 100);
        break;

      case WalkingDirection.right:
        velocity = Vector2(100, 0);
        break;
    }
  }
}

enum WalkingDirection {
  up,
  down,
  left,
  right,
  upLeft,
  upRight,
  downLeft,
  downRight,
}
