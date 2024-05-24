import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:gravity_guy/components/inherited_components/game_part.dart';
import 'package:gravity_guy/components/proxima_space_station_game_part/map_proxima_space_station.dart';

import '../components/proxima_space_station_game_part/astronaut_indoor_top_down_character_part.dart';

class ProximaSpaceStationGamePart extends GamePart {
  double mapWidth = 0;
  double mapHeight = 0;
  late MapProximaSpaceStation map;
  @override
  Future<void> onLoad() async {
    final proximaLevelTiledComponent =
        await TiledComponent.load("control_room.tmx", Vector2.all(16));

    mapWidth = proximaLevelTiledComponent.tileMap.map.width *
        proximaLevelTiledComponent.tileMap.destTileSize.x;
    mapHeight = proximaLevelTiledComponent.tileMap.map.height *
        proximaLevelTiledComponent.tileMap.destTileSize.y;

    map = MapProximaSpaceStation(
        tileMapBackgroundComposite: proximaLevelTiledComponent,
        mapWidth: mapWidth,
        mapHeight: mapHeight);

    final startingPosition =
        Vector2(mapWidth / 2 + 64, mapHeight / 2 + 128 + 32);

    final astronaut = AstronautIndoorTopDownCharacterPart(
      startingPosition: startingPosition,
    );

    world.add(map);
    world.add(astronaut);

    camera.viewfinder.visibleGameSize = Vector2(mapWidth / 2, mapHeight / 2);
    camera.follow(astronaut);
    camera.viewfinder.anchor = Anchor.center;
  }
}
