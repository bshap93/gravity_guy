import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'behind_obstacle_hitbox.dart';

class MidRoomBeamMapObject extends PositionComponent {
  MidRoomBeamMapObject({
    required this.tileObject,
    required this.startingPosition,
  }) : super(position: startingPosition, anchor: Anchor.center);

  final Vector2 startingPosition;
  final TiledComponent tileObject;
  late RectangleHitbox midRoomBeamHitbox;
  late BehindObstacleArea aboveBeamHitbox;
  @override
  void onLoad() {
    super.onLoad();
    priority = 1;
    position = startingPosition;
    add(tileObject);
    midRoomBeamHitbox =
        // Bottom
        RectangleHitbox(
      size: Vector2(tileObject.width / 2 - 16, 2),
      position: Vector2(24, 45),
      anchor: Anchor.center,
    );

    aboveBeamHitbox =
        // Bottom
        BehindObstacleArea(
      size: Vector2(tileObject.width, 6),
      position: Vector2(32, 0),
    );

    add(midRoomBeamHitbox);
    add(aboveBeamHitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
