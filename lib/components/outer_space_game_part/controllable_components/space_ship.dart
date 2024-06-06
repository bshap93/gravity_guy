import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:gravity_guy/components/outer_space_game_part/ui_components/interaction_text.dart';

import '../../../game_parts/outer_space_game_part.dart';
import '../environment_components/rocky_moon.dart';
import 'astronaut_outdoor_character_part.dart';

class SpaceShip extends SpriteAnimationComponent
    with HasGameRef<OuterSpaceGamePart>, CollisionCallbacks {
  Vector2 initialPosition = Vector2(500, 825);
  Vector2 textureSize = Vector2(112, 48);
  double lengthAcross = 75;
  bool isTouchedByAstronaut = false;

  Vector2 velocity = Vector2.zero();
  Vector2 acceleration = Vector2.zero();

  bool isFlying = false;
  bool isOccupied = false;
  bool inOrbit = false;
  bool isTakingOff = false;
  bool isUnderUserControlledThrust = false;

  bool isThrustingUp = false;
  bool isThrustingDown = false;
  bool isThrustingLeft = false;
  bool isThrustingRight = false;

  double thrustAngle = 0.0;
  double thrustPower = 25.0;

  InteractionText enterSpaceShipText = InteractionText(
      positionVector: Vector2(0, 0), text: 'Press X to enter', angle: 0);

  SpaceShip({required Vector2 initialPosition, required double initialAngle})
      : super(
            // size: ,
            anchor: Anchor.center,
            angle: pi + pi / 16);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    priority = 10;

    animation = await game.loadSpriteAnimation(
        'spaceship_02.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: textureSize,
        ));
    // For now the spaceship is represented as a square
    size = Vector2(3 * lengthAcross, lengthAcross);

    position = initialPosition;
    playing = false;
    add(RectangleHitbox(
      size: Vector2(width, height),
      position: Vector2(0, 0),
      anchor: Anchor.center,
    ));
  }

  void acceptAstronaut() {
    isOccupied = true;
    isFlying = true;
    game.canGuyEnterShip = false;
    game.isGuyOutsideShip = false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isFlying) {
      playing = true;
    } else {
      playing = false;
    }

    position += velocity * dt;

    velocity += acceleration * dt;

    if (isTakingOff) {
      sprayParticlesBack(0);
    }

    if (isUnderUserControlledThrust) {}

    if (isThrustingUp) {
      thrustForward();
      sprayParticlesBack(thrustAngle);
    }

    if (isThrustingDown) {
      thrustBackward();
      sprayParticlesBack(thrustAngle);
    }

    if (isThrustingLeft) {
      thrustLeft();
      sprayParticlesBack(thrustAngle);
    }

    if (isThrustingRight) {
      thrustRight();
      sprayParticlesBack(thrustAngle);
    }
  }

  void sprayParticlesBack(double angle) {
    final rnd = Random();

    add(
      ParticleSystemComponent(
        angle: angle,
        particle: AcceleratedParticle(
          // Will fire off in the center of game canvas
          position: Vector2(150, 50),

          // With random initial speed of Vector2(-100..100, 0..-100)
          speed:
              -Vector2(rnd.nextDouble() * 200 - 100, -rnd.nextDouble() * 100),
          // Accelerating downwards, simulating "gravity"
          // speed: Vector2(0, 100),
          child: CircleParticle(
            radius: 2.0,
            paint: Paint()..color = Colors.white,
          ),
        ),
      ),
    );
    add(
      ParticleSystemComponent(
        angle: angle,
        particle: AcceleratedParticle(
          // Will fire off in the center of game canvas
          position: Vector2(75, 50),
          // With random initial speed of Vector2(-100..100, 0..-100)
          speed:
              -Vector2(rnd.nextDouble() * 200 - 100, -rnd.nextDouble() * 100),
          // Accelerating downwards, simulating "gravity"
          // speed: Vector2(0, 100),
          child: CircleParticle(
            radius: 2.0,
            paint: Paint()..color = Colors.white,
          ),
        ),
      ),
    );
  }

  void blastOff() {
    final rockyMoon = gameRef.world.children.firstWhere(
      (element) => element is RockyMoon,
    ) as RockyMoon;
    final gravityDirection = rockyMoon.position - position;
    isThrustingDown = true;

    velocity -= gravityDirection.normalized() * 50;
    game.camera.viewfinder.position = position;

    Future.delayed(const Duration(seconds: 3), () {
      velocity = Vector2.zero();
      rockyMoon.startSpinning();
      isThrustingDown = false;

      gameRef.alertUserToRadioForeman();
    });
  }

  void bobInPlace() {}

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is AstronautOutdoorCharacterPart) {
      isTouchedByAstronaut = true;
      add(enterSpaceShipText);
      game.canGuyEnterShip = true;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is AstronautOutdoorCharacterPart) {
      remove(enterSpaceShipText);
      game.canGuyEnterShip = false;
    }
  }

  void driftOut() {
    final planet = gameRef.world.children.firstWhere(
      (element) => element is RockyMoon,
    ) as RockyMoon;
    final gravityDirection = planet.position - position;
    velocity -= gravityDirection.normalized() * thrustPower;
    isTakingOff = true;

    Future.delayed(const Duration(seconds: 2), () {
      final hud = gameRef.hudComponent;
      hud.updateMessage("Thrust forward to navigate the ship.");
      isUnderUserControlledThrust = true;
      isTakingOff = false;
    });
  }

  void thrustForward() {
    final thrustDirection = Vector2(0, -1).normalized();
    velocity += thrustDirection * thrustPower;
    thrustAngle = 0;
    sprayParticlesBack(thrustAngle);
  }

  void thrustBackward() {
    final thrustDirection = Vector2(0, 1).normalized();
    velocity += thrustDirection * thrustPower;
    thrustAngle = pi;
    sprayParticlesBack(thrustAngle);
  }

  void thrustLeft() {
    final thrustDirection = Vector2(-1, 0).normalized();
    velocity += thrustDirection * thrustPower;
    thrustAngle = -pi / 2;
    sprayParticlesBack(thrustAngle);
  }

  void thrustRight() {
    final thrustDirection = Vector2(1, 0).normalized();
    velocity += thrustDirection * thrustPower;
    thrustAngle = pi / 2;
    sprayParticlesBack(thrustAngle);
  }
}
