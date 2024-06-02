import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gravity_guy/components/inherited_components/game_part.dart';
import 'package:gravity_guy/components/proxima_space_station_game_part/bottom_map_proxima_space_station.dart';

import '../components/proxima_space_station_game_part/astronaut_indoor_top_down_character_part.dart';
import '../components/proxima_space_station_game_part/mid_room_beam_map_object.dart';

class ProximaSpaceStationGamePart extends GamePart with TapDetector {
  double mapWidth = 0;
  double mapHeight = 0;
  double tileWidth = 32;
  late BottomMapProximaSpaceStation bottomMap;
  late MidRoomBeamMapObject midRoomBeamObject;
  @override
  Future<void> onLoad() async {
    final proximaLevelTiledComponent =
        await TiledComponent.load("control_room_bottom.tmx", Vector2.all(16));

    final controlRoomMidroomBeamTiledComponent = await TiledComponent.load(
        "control_room_midroom_beam.tmx", Vector2.all(16));

    mapWidth = proximaLevelTiledComponent.tileMap.map.width *
        proximaLevelTiledComponent.tileMap.destTileSize.x;
    mapHeight = proximaLevelTiledComponent.tileMap.map.height *
        proximaLevelTiledComponent.tileMap.destTileSize.y;

    bottomMap = BottomMapProximaSpaceStation(
        tileMapBackgroundBottom: proximaLevelTiledComponent,
        mapWidth: mapWidth,
        mapHeight: mapHeight);
    final startingPosition = Vector2(264, 360);
    final beamPositions = [
      Vector2(150, 150),
    ];

    midRoomBeamObject = MidRoomBeamMapObject(
      tileObject: controlRoomMidroomBeamTiledComponent,
      startingPosition: beamPositions[0],
    );

    final astronaut = AstronautIndoorTopDownCharacterPart(
      startingPosition: startingPosition,
    );

    world.add(bottomMap);

    world.add(midRoomBeamObject);
    world.add(astronaut);
    // world.add(topMap);

    camera.viewfinder.visibleGameSize = Vector2(mapWidth / 2, mapHeight / 2);
    camera.follow(astronaut);
    camera.viewfinder.anchor = Anchor.center;
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isArrowRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isArrowLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isArrowUp = keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isArrowDown = keysPressed.contains(LogicalKeyboardKey.arrowDown);

    final astronaut = world.children.firstWhere(
      (element) => element is AstronautIndoorTopDownCharacterPart,
    ) as AstronautIndoorTopDownCharacterPart;

    if (isArrowRight) {
      // The astronaut is not allowed to go beyond the right boundary
      astronaut.walk(WalkingDirection.right);
    } else if (isArrowLeft) {
      astronaut.walk(WalkingDirection.left);
    } else if (isArrowUp) {
      astronaut.walk(WalkingDirection.up);
    } else if (isArrowDown) {
      astronaut.walk(WalkingDirection.down);
    } else {
      astronaut.velocity = Vector2.zero();
      astronaut.animation = astronaut.stationaryAnimation;
    }

    return KeyEventResult.handled;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onTap() {
    // TODO: implement onTap
    super.onTap();
    if (kDebugMode) {
      print('Tapped');
    }
  }
}
