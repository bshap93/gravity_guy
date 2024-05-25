import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../inherited_components/astronaut.dart';
import 'bottom_map_proxima_space_station.dart';

class AstronautIndoorTopDownCharacterPart extends Astronaut {
  AstronautIndoorTopDownCharacterPart({required this.startingPosition})
      : super(
          hitBoxRadius: 32,
        );

  final Vector2 startingPosition;
  double tileWidth = 32;
  bool hitLeftBarrier = false;
  bool hitRightBarrier = false;
  bool hitTopBarrier = false;
  bool hitBottomBarrier = false;

  late WalkingDirection walkingDirection;
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
    if (other is BottomMapProximaSpaceStation) {
      velocity = Vector2.zero();
      if (walkingDirection == WalkingDirection.up) {
        hitTopBarrier = true;
      } else if (walkingDirection == WalkingDirection.down) {
        hitBottomBarrier = true;
      } else if (walkingDirection == WalkingDirection.left) {
        hitLeftBarrier = true;
      } else if (walkingDirection == WalkingDirection.right) {
        hitRightBarrier = true;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is BottomMapProximaSpaceStation) {
      hitTopBarrier = false;
      hitBottomBarrier = false;
      hitLeftBarrier = false;
      hitRightBarrier = false;
    }
  }

  void walk(WalkingDirection direction) {
    switch (direction) {
      case WalkingDirection.up:
        // The astronaut is not allowed to go above the top boundary
        walkingDirection = WalkingDirection.up;
        if (!hitTopBarrier) {
          velocity = Vector2(0, -100);
        }
        break;
      case WalkingDirection.down:
        // The astronaut is not allowed to go below the bottom boundary
        if (!hitBottomBarrier) {
          walkingDirection = WalkingDirection.down;
          velocity = Vector2(0, 100);
        } else {
          velocity = Vector2.zero();
        }
        break;
      case WalkingDirection.left:
        walkingDirection = WalkingDirection.left;
        if (!hitLeftBarrier) {
          velocity = Vector2(-100, 0);
        }

        break;

      case WalkingDirection.right:
        walkingDirection = WalkingDirection.right;
        if (!hitRightBarrier) {
          velocity = Vector2(100, 0);
        }
        break;
    }
  }
}

enum WalkingDirection {
  up,
  down,
  left,
  right,
}
