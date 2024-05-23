import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

class ProximaSpaceStationGamePart extends FlameGame
    with KeyboardEvents, HasCollisionDetection {
  double mapWidth = 0;
  double mapHeight = 0;
  @override
  Future<void> onLoad() async {
    final level =
        await TiledComponent.load("control_room.tmx", Vector2.all(16));

    mapWidth = level.tileMap.map.width * level.tileMap.destTileSize.x;
    mapHeight = level.tileMap.map.height * level.tileMap.destTileSize.y;

    world.add(level);

    camera.viewfinder.visibleGameSize = Vector2(mapWidth / 2, mapHeight / 2);
    camera.viewfinder.position = Vector2(mapWidth / 2, mapHeight / 2);
    camera.viewfinder.anchor = Anchor.center;
  }
}
