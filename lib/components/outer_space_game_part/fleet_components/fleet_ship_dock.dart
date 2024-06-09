import 'dart:async';

import 'package:flame/components.dart';

class FleetShipDock extends PositionComponent {
  FleetShipDock({required this.dockingPosition, required this.initialAngle});

  final Vector2 dockingPosition;
  final double initialAngle;

  @override
  FutureOr<void> onLoad() {
    return super.onLoad();
  }
}
