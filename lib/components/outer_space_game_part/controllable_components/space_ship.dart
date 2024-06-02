import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:gravity_guy/components/outer_space_game_part/ui_components/interaction_text.dart';

import '../../../game_parts/outer_space_game_part.dart';
import '../../../hud.dart';
import '../environment_components/planet.dart';
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
      sprayParticlesOnTakeOff(Vector2.zero());
    }
  }

  void sprayParticlesOnTakeOff(Vector2 gravityDirection) {
    final rnd = Random();

    add(
      ParticleSystemComponent(
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
    final planet = gameRef.world.children.firstWhere(
      (element) => element is Planet,
    ) as Planet;
    final gravityDirection = planet.position - position;
    isTakingOff = true;

    velocity -= gravityDirection.normalized() * 50;
    game.camera.viewfinder.position = position;

    Future.delayed(const Duration(seconds: 3), () {
      velocity = Vector2.zero();
      isFlying = false;
      inOrbit = true;
      isTakingOff = false;
      planet.startSpinning();
      bobInPlace();
      final HUDComponent hud = gameRef.hudComponent;
      hud.updateMessage("You're in space! Press C to contact the Swarm Liason");
    });
  }

  void bobInPlace() {
    final planet = gameRef.world.children.firstWhere(
      (element) => element is Planet,
    ) as Planet;
    final gravityDirection = planet.position - position;
  }

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
}
