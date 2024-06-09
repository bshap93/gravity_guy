import 'package:flame/components.dart';

import '../../../game_parts/outer_space_game_part.dart';
import 'fleet_ship.dart';

class Fleet extends PositionComponent with HasGameRef<OuterSpaceGamePart> {
  late List<FleetShip> fleetShips;

  late FleetShip capitalShip;

  Fleet();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    fleetShips = [];

    capitalShip = FleetShip(
        positionVector: Vector2(
          1000,
          2200,
        ),
        initialAngle: 3.33794219,
        shipImageName: 'capital_ship_01',
        textureSize: Vector2(496, 128),
        parentSize: Vector2(992, 256));

    add(capitalShip);

    // fleetShips.add(capitalShip);
    //
    // for (final FleetShip fleetShip in fleetShips) {
    //   add(fleetShip);
    // }
  }
}
