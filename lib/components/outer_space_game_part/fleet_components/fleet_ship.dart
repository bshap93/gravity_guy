import 'package:flame/components.dart';

import 'fleet_ship_visual_layer.dart';

class FleetShip extends PositionComponent {
  FleetShip({required this.positionVector, required this.initialAngle});

  final Vector2 positionVector;
  final double initialAngle;

  late FleetShipVisualLayer fleetShipVisualLayer;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = positionVector;
  }
}
