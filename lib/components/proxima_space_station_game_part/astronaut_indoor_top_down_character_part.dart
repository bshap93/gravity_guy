import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../inherited_components/astronaut.dart';
import '../outer_space_game_part/controllable_components/astronaut_outdoor_character_part.dart';
import 'behind_obstacle_hitbox.dart';
import 'bottom_map_proxima_space_station.dart';
import 'mid_room_beam_map_object.dart';

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

  late SpriteAnimation walkingAnimation;

  late WalkingDirection walkingDirection;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = startingPosition;
    priority = 5;

    walkingAnimation = SpriteAnimation.fromFrameData(
        spriteSheet.image,
        SpriteAnimationData([
          spriteSheet.createFrameData(0, 2, stepTime: 0.12),
          spriteSheet.createFrameData(0, 3, stepTime: 0.12),
          spriteSheet.createFrameData(0, 4, stepTime: 0.12),
          spriteSheet.createFrameData(0, 5, stepTime: 0.12),
          // spriteSheet.createFrameData(0, 4, stepTime: 0.1),
        ]));

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
      stopDead();
    }

    if (other is MidRoomBeamMapObject) {
      print('hit beam');
      stopDead();
    }

    if (other is BehindObstacleArea) {
      print('hit behind obstacle');
      other.parent?.priority = 10;
    }
  }

  void stopDead() {
    velocity = Vector2.zero();
    if (walkingDirection == WalkingDirection.up) {
      hitTopBarrier = true;
      // Inch the astronaut back a little bit to avoid getting stuck
      position += Vector2(0, .1);
    } else if (walkingDirection == WalkingDirection.down) {
      hitBottomBarrier = true;
      position -= Vector2(0, .1);
    } else if (walkingDirection == WalkingDirection.left) {
      hitLeftBarrier = true;
      position += Vector2(.1, 0);
    } else if (walkingDirection == WalkingDirection.right) {
      hitRightBarrier = true;
      position -= Vector2(.1, 0);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is BottomMapProximaSpaceStation ||
        other is MidRoomBeamMapObject) {
      hitTopBarrier = false;
      hitBottomBarrier = false;
      hitLeftBarrier = false;
      hitRightBarrier = false;
    }

    if (other is BehindObstacleArea) {
      other.parent?.priority = 1;
    }
  }

  void walk(WalkingDirection direction) {
    animation = walkingAnimation;
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
        }
        break;
      case WalkingDirection.left:
        if (orientedDirection == SpriteOrientedDirection.right) {
          changeDirection(SpriteOrientedDirection.left);
        }
        walkingDirection = WalkingDirection.left;
        if (!hitLeftBarrier) {
          velocity = Vector2(-100, 0);
        }

        break;

      case WalkingDirection.right:
        if (orientedDirection == SpriteOrientedDirection.left) {
          changeDirection(SpriteOrientedDirection.right);
        }
        walkingDirection = WalkingDirection.right;
        if (!hitRightBarrier) {
          velocity = Vector2(100, 0);
        }
        break;
    }
  }

  changeDirection(SpriteOrientedDirection direction) {
    if (direction == SpriteOrientedDirection.left &&
        orientedDirection == SpriteOrientedDirection.right) {
      orientedDirection = SpriteOrientedDirection.left;
      // flipHorizontally();
    }

    if (direction == SpriteOrientedDirection.right &&
        orientedDirection == SpriteOrientedDirection.left) {
      orientedDirection = SpriteOrientedDirection.right;
      // flipHorizontally();
    }
  }
}

enum WalkingDirection {
  up,
  down,
  left,
  right,
}
