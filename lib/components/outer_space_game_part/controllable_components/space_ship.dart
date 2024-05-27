import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gravity_guy/components/outer_space_game_part/ui_components/interaction_text.dart';

import '../../../game_parts/outer_space_game_part.dart';
import '../../../overlays/hud.dart';
import '../environment_components/planet.dart';
import 'astronaut_outdoor_character_part.dart';

class SpaceShip extends SpriteAnimationComponent
    with HasGameRef<OuterSpaceGamePart>, CollisionCallbacks {
  Vector2 initialPosition = Vector2(500, 775);
  Vector2 textureSize = Vector2(32, 32);
  double lengthAcross = 75;
  bool isTouchedByAstronaut = false;

  Vector2 velocity = Vector2.zero();
  Vector2 acceleration = Vector2.zero();

  bool isFlying = false;
  bool isOccupied = false;

  InteractionText enterSpaceShipText = InteractionText(
      positionVector: Vector2(500, 900), text: 'Press X to enter');

  SpaceShip()
      : super(
            // size: ,
            anchor: Anchor.center,
            angle: pi);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
        'spaceShip1.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: textureSize,
        ));
    // For now the spaceship is represented as a square
    size = Vector2(lengthAcross, lengthAcross);

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
  }

  void blastOff() {
    final planet = gameRef.world.children.firstWhere(
      (element) => element is Planet,
    ) as Planet;
    final gravityDirection = planet.position - position;

    velocity -= gravityDirection.normalized() * 50;
    game.camera.viewfinder.position = position;

    Future.delayed(const Duration(seconds: 3), () {
      velocity = Vector2.zero();
      isFlying = false;
      planet.startSpinning();
      final Hud hud = gameRef.hud;
      hud.updateMessage("You're in space! Press C to contact the Swarm Liason");
    });
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
