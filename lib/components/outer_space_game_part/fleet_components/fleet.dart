import 'package:flame/components.dart';

import '../../../game_parts/outer_space_game_part.dart';
import 'fleet_ship.dart';

class Fleet extends PositionComponent with HasGameRef<OuterSpaceGamePart> {
  late List<FleetShip> fleetShips;

  Fleet();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    fleetShips = [];

    final FleetShip capitalShip = FleetShip(
      positionVector: Vector2(
        512,
        1024,
      ),
      initialAngle: 3.33794219,
    );
  }
}
