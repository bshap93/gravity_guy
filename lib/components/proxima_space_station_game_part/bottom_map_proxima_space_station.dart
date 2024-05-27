import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../../game_parts/proxima_space_station_game_part.dart';

const double tileSize = 16;
const double halfTileSize = 8;

class BottomMapProximaSpaceStation extends PositionComponent
    with HasGameRef<ProximaSpaceStationGamePart> {
  late CompositeHitbox lv1RoomOutsideBoundaryHitbox;
  late CompositeHitbox lvl1RoomObstacleHitboxes;
  TiledComponent tileMapBackgroundBottom;
  double mapWidth;
  double mapHeight;

  BottomMapProximaSpaceStation({
    required this.tileMapBackgroundBottom,
    required this.mapWidth,
    required this.mapHeight,
  });

  @override
  void onLoad() {
    add(tileMapBackgroundBottom);
    priority = 0;

    lv1RoomOutsideBoundaryHitbox = CompositeHitbox(children: [
      // Bottom
      RectangleHitbox(
        size: Vector2(mapWidth, tileSize),
        position: Vector2(mapWidth / 2, mapHeight + tileSize),
        anchor: Anchor.center,
      ),
      // Left
      RectangleHitbox(
        size: Vector2(tileSize, mapHeight + tileSize),
        position: Vector2(-tileSize * 3, mapHeight / 2),
        anchor: Anchor.center,
      ),
      // Right
      RectangleHitbox(
        size: Vector2(tileSize, mapHeight + tileSize),
        position: Vector2(mapWidth + tileSize, mapHeight / 2),
        anchor: Anchor.center,
      ),
      // Top
      RectangleHitbox(
        size: Vector2(mapWidth, tileSize),
        position: Vector2(mapWidth / 2, tileSize * 5),
        anchor: Anchor.center,
      ),
    ]);
    add(lv1RoomOutsideBoundaryHitbox);

    // lvl1RoomObstacleHitboxes = CompositeHitbox(children: [
    //   // Bottom
    //   RectangleHitbox(
    //     size: Vector2(tileSize * 2, halfTileSize),
    //     position: Vector2(mapWidth / 2 + halfTileSize * 6, halfTileSize * 25),
    //     anchor: Anchor.center,
    //   ),
    // ]);

    // add(lvl1RoomObstacleHitboxes);
  }
}
