import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:gravity_guy/components/outer_space_game_part/controllable_components/space_ship/space_ship_visual_layer.dart';
import 'package:gravity_guy/components/outer_space_game_part/ui_components/interaction_text.dart';

import '../../../../game_parts/outer_space_game_part.dart';
import '../../environment_components/rocky_moon/rocky_moon.dart';
import '../../fleet_components/fleet_ship.dart';
import '../astronaut_outdoor_character_part.dart';

class SpaceShip extends PositionComponent
    with HasGameRef<OuterSpaceGamePart>, CollisionCallbacks {
  Vector2 initialPosition = Vector2(500, 825);

  late SpaceShipVisualLayer spaceShipVisualLayer;
  List<FleetShip> dockableFleetShips = [];

  double lengthAcross = 75;
  bool isTouchedByAstronaut = false;

  Vector2 velocity = Vector2.zero();
  Vector2 acceleration = Vector2.zero();

  bool isFlying = false;
  bool isOccupied = false;
  bool inOrbit = false;
  bool isTakingOff = false;
  bool isUnderUserControlledThrust = false;

  bool thrustingUp = false;
  bool thrustingDown = false;
  bool thrustingRight = false;
  bool thrustingLeft = false;
  bool bobbing = false;

  double thrustAngle = 0.0;
  double thrustPower = 75.0;

  InteractionText enterSpaceShipText = InteractionText(
      positionVector: Vector2(0, 0), text: 'Press X to enter', angle: 0);

  SpaceShip({required double initialAngle})
      : super(
            // size: ,
            anchor: Anchor.center,
            angle: 3.33794219);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    priority = 10;
    position = initialPosition;
    // For now the spaceship is represented as a square
    size = Vector2(3 * lengthAcross, lengthAcross);
    spaceShipVisualLayer = SpaceShipVisualLayer(
      parentSize: size,
    );

    add(RectangleHitbox(
      size: Vector2(width, height),
      position: Vector2(0, 0),
      anchor: Anchor.topLeft,
    ));

    add(spaceShipVisualLayer);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += velocity * dt;

    velocity += acceleration * dt;

    if (thrustingUp) {
      thrustUp();
    }

    if (thrustingDown) {
      thrustDown();
    }

    if (thrustingRight) {
      thrustLeft();
    }

    if (thrustingLeft) {
      thrustRight();
    }
  }

  void acceptAstronaut() {
    isOccupied = true;
    isFlying = true;
    game.canGuyEnterShip = false;
    game.isGuyOutsideShip = false;
  }

  void thrustDown() {
    final thrustDirection = Vector2(0, -1).normalized();
    velocity = thrustDirection * thrustPower;
    thrustAngle = 0;
    spaceShipVisualLayer.sprayParticlesBack(0);
  }

  void thrustUp() {
    final thrustDirection = Vector2(0, 1).normalized();
    velocity = thrustDirection * thrustPower;
    thrustAngle = pi;
    spaceShipVisualLayer.sprayParticlesBack(0);
  }

  void thrustLeft() {
    final thrustDirection = Vector2(-1, 0).normalized();
    velocity = thrustDirection * thrustPower;
    thrustAngle = -pi / 2;
    spaceShipVisualLayer.sprayParticlesBack(0);
  }

  void thrustRight() {
    final thrustDirection = Vector2(1, 0).normalized();
    velocity = thrustDirection * thrustPower;
    thrustAngle = pi / 2;
    spaceShipVisualLayer.sprayParticlesBack(0);
  }

  void cutThrust() {
    velocity = Vector2.zero();
    spaceShipVisualLayer.bobInPlace();
  }

  void engageShield() {
    spaceShipVisualLayer.shield.engage();
  }

  void blastOff() {
    final rockyMoon = gameRef.world.children.firstWhere(
      (element) => element is RockyMoon,
    ) as RockyMoon;
    final gravityDirection = rockyMoon.position - position;
    thrustingUp = true;

    velocity += gravityDirection.normalized() * 10;
    game.camera.viewfinder.position = position;

    Future.delayed(const Duration(seconds: 3), () {
      velocity = Vector2.zero();
      rockyMoon.startSpinning();
      thrustingUp = false;
      isUnderUserControlledThrust = true;

      engageShield();
      spaceShipVisualLayer.bobInPlace();

      gameRef.alertUserToRadioForeman();
    });
  }

  void dockWithFleetShip() {
    if (dockableFleetShips.isEmpty) {
      return;
    } else if (dockableFleetShips.length == 1) {
      final fleetShipDockPosition =
          dockableFleetShips.first.fleetShipDock.position;
      final moveToEffect = MoveToEffect(
        fleetShipDockPosition,
        target: this,
        EffectController(duration: 1),
      );
      add(moveToEffect);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is AstronautOutdoorCharacterPart) {
      print('Astronaut is touching spaceship');
      isTouchedByAstronaut = true;
      add(enterSpaceShipText);
      game.canGuyEnterShip = true;
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is FleetShip) {
      dockableFleetShips.add(other);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is AstronautOutdoorCharacterPart) {
      remove(enterSpaceShipText);
      game.canGuyEnterShip = false;
    }

    if (other is FleetShip) {
      dockableFleetShips.remove(other);
    }
  }
}
