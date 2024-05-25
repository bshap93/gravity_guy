import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gravity_guy/game_parts/proxima_space_station_game_part.dart';

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

  WalkingDirection walkingDirection = WalkingDirection.right;
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
    final mapWidth = (gameRef as ProximaSpaceStationGamePart).mapWidth;
    final mapHeight = (gameRef as ProximaSpaceStationGamePart).mapHeight;

    switch (direction) {
      case WalkingDirection.up:
        // The astronaut is not allowed to go above the top boundary
        if (position.y > tileWidth * 5.0 && !hitTopBarrier) {
          velocity = Vector2(0, -100);
        }
        break;
      case WalkingDirection.down:
        // The astronaut is not allowed to go below the bottom boundary
        if (position.y < mapHeight - tileWidth && !hitBottomBarrier) {
          velocity = Vector2(0, 100);
        }
        break;
      case WalkingDirection.left:
        if (position.x > tileWidth && !hitLeftBarrier) {
          velocity = Vector2(-100, 0);
        }

        break;

      case WalkingDirection.right:
        if (position.x < mapWidth - tileWidth && !hitRightBarrier) {
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
