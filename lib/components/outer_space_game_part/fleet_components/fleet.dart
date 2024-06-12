import 'package:flame/components.dart';

import '../../../game_parts/outer_space_game_part.dart';
import 'fleet_ship.dart';

class Fleet extends PositionComponent with HasGameRef<OuterSpaceGamePart> {
  late List<FleetShip> fleetShips;

  late FleetShip capitalShip;
  late FleetShip corvette;
  late FleetShip habShip;

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
        parentSize: Vector2(992, 256),
        bobDelay: 0);

    add(capitalShip);

    fleetShips.add(capitalShip);

    corvette = FleetShip(
        positionVector: Vector2(
          400,
          2400,
        ),
        initialAngle: 3.33794219,
        shipImageName: 'corvette_01',
        bobDelay: 1000,
        textureSize: Vector2(368, 112),
        parentSize: Vector2(736, 224));

    add(corvette);

    fleetShips.add(capitalShip);

    habShip = FleetShip(
        positionVector: Vector2(
          1500,
          2400,
        ),
        initialAngle: 3.33794219,
        shipImageName: 'hab_ship_01',
        bobDelay: 500,
        textureSize: Vector2(368, 112),
        parentSize: Vector2(736, 224));

    add(habShip);
    fleetShips.add(habShip);
  }
}
