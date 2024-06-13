import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gravity_guy/components/outer_space_game_part/controllable_components/space_ship/space_ship.dart';

import '../../../game_parts/outer_space_game_part.dart';
import 'fleet_ship_visual_layer.dart';

class FleetShip extends PositionComponent
    with CollisionCallbacks, HasGameRef<OuterSpaceGamePart> {
  FleetShip({
    required this.positionVector,
    required this.initialAngle,
    required this.shipImageName,
    required this.textureSize,
    required this.parentSize,
    required this.bobDelay,
  });

  final Vector2 positionVector;
  final double initialAngle;
  final String shipImageName;
  final Vector2 textureSize;
  final Vector2 parentSize;
  final double bobDelay;
  late List<Vector2> dockingPositions = [];

  late FleetShipVisualLayer fleetShipVisualLayer;
  late RectangleHitbox interactionRange;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = positionVector;
    angle = initialAngle;

    fleetShipVisualLayer = FleetShipVisualLayer(
      textureSize: textureSize, // Vector2(496, 128),
      parentSize: parentSize, //  Vector2(992, 256),
      parentPriority: 9,
      shipImageName: shipImageName,
      parentAngle: initialAngle,
    );

    add(fleetShipVisualLayer);

    interactionRange = RectangleHitbox(
      size: Vector2(parentSize.x * 1.5, parentSize.y * 2),
      position: Vector2(-0.25 * parentSize.x, -0.5 * parentSize.y),
      anchor: Anchor.topLeft,
    );

    add(interactionRange);

    dockingPositions.add(
      Vector2(0.5 * parentSize.x, 0.5 * parentSize.y),
    );
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is SpaceShip) {
      if (!gameRef.skipIntro) {
        gameRef.hudComponent
            .updateMessage('Press D to dock with the Capital Ship');
      }
    }
  }
}
