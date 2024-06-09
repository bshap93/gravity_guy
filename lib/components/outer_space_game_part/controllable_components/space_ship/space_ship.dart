import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gravity_guy/components/outer_space_game_part/controllable_components/space_ship/space_ship_visual_layer.dart';
import 'package:gravity_guy/components/outer_space_game_part/ui_components/interaction_text.dart';

import '../../../../game_parts/outer_space_game_part.dart';
import '../../environment_components/rocky_moon.dart';
import '../astronaut_outdoor_character_part.dart';

class SpaceShip extends PositionComponent
    with HasGameRef<OuterSpaceGamePart>, CollisionCallbacks {
  Vector2 initialPosition = Vector2(500, 825);

  late SpaceShipVisualLayer spaceShipVisualLayer;
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
            angle: pi + pi / 16);

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
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is AstronautOutdoorCharacterPart) {
      remove(enterSpaceShipText);
      game.canGuyEnterShip = false;
    }
  }
}

// class SpaceShip extends SpriteAnimationComponent
//     with HasGameRef<OuterSpaceGamePart>, CollisionCallbacks {
//   Vector2 initialPosition = Vector2(500, 825);
//   Vector2 textureSize = Vector2(112, 48);
//   double lengthAcross = 75;
//   bool isTouchedByAstronaut = false;
//
//   Vector2 velocity = Vector2.zero();
//   Vector2 acceleration = Vector2.zero();
//
//   bool isFlying = false;
//   bool isOccupied = false;
//   bool inOrbit = false;
//   bool isTakingOff = false;
//   bool isUnderUserControlledThrust = false;
//
//   bool thrustingUp = false;
//   bool thrustingDown = false;
//   bool thrustingRight = false;
//   bool thrustingLeft = false;
//   bool bobbing = false;
//
//   double thrustAngle = 0.0;
//   double thrustPower = 75.0;
//
//   late Shield shield;
//
//   InteractionText enterSpaceShipText = InteractionText(
//       positionVector: Vector2(0, 0), text: 'Press X to enter', angle: 0);
//
//   SpaceShip({required Vector2 initialPosition, required double initialAngle})
//       : super(
//             // size: ,
//             anchor: Anchor.center,
//             angle: pi + pi / 16);
//
//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();
//     priority = 10;
//
//     animation = await game.loadSpriteAnimation(
//         'spaceship_02.png',
//         SpriteAnimationData.sequenced(
//           amount: 1,
//           stepTime: 0.1,
//           textureSize: textureSize,
//         ));
//     // For now the spaceship is represented as a square
//     size = Vector2(3 * lengthAcross, lengthAcross);
//
//     position = initialPosition;
//
//     add(RectangleHitbox(
//       size: Vector2(width, height),
//       position: Vector2(0, 0),
//       anchor: Anchor.topLeft,
//     ));
//
//     shield = Shield(position: Vector2(width / 2, height / 2));
//     add(shield);
//   }
//
//   void acceptAstronaut() {
//     isOccupied = true;
//     isFlying = true;
//     game.canGuyEnterShip = false;
//     game.isGuyOutsideShip = false;
//   }
//
//   @override
//   void update(double dt) {
//     super.update(dt);
//     if (isFlying) {
//       playing = true;
//     } else {
//       playing = false;
//     }
//
//     position += velocity * dt;
//
//     velocity += acceleration * dt;
//
//     if (thrustingUp) {
//       thrustUp();
//     }
//
//     if (thrustingDown) {
//       thrustDown();
//     }
//
//     if (thrustingRight) {
//       thrustLeft();
//     }
//
//     if (thrustingLeft) {
//       thrustRight();
//     }
//   }
//
//   void sprayParticlesBack(double angle) {
//     final rnd = Random();
//
//     add(
//       ParticleSystemComponent(
//         angle: angle,
//         anchor: Anchor.center,
//         particle: AcceleratedParticle(
//           // Will fire off in the center of game canvas
//           position: Vector2(2 * width / 5, 4 * height / 5),
//
//           // With random initial speed of Vector2(-100..100, 0..-100)
//           speed:
//               -Vector2(rnd.nextDouble() * 200 - 100, -rnd.nextDouble() * 100),
//           // Accelerating downwards, simulating "gravity"
//           // speed: Vector2(0, 100),
//           child: CircleParticle(
//             radius: 2.0,
//             paint: Paint()..color = Colors.white,
//           ),
//         ),
//       ),
//     );
//     add(
//       ParticleSystemComponent(
//         anchor: Anchor.center,
//         angle: angle,
//         particle: AcceleratedParticle(
//           // Will fire off in the center of game canvas
//           position: Vector2(3 * width / 5, 4 * height / 5),
//           // With random initia l speed of Vector2(-100..100, 0..-100)
//           speed:
//               -Vector2(rnd.nextDouble() * 200 - 100, -rnd.nextDouble() * 100),
//           // Accelerating downwards, simulating "gravity"
//           // speed: Vector2(0, 100),
//           child: CircleParticle(
//             radius: 2.0,
//             paint: Paint()..color = Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
//
//   void blastOff() {
//     final rockyMoon = gameRef.world.children.firstWhere(
//       (element) => element is RockyMoon,
//     ) as RockyMoon;
//     final gravityDirection = rockyMoon.position - position;
//     thrustingUp = true;
//
//     velocity += gravityDirection.normalized() * 10;
//     game.camera.viewfinder.position = position;
//
//     Future.delayed(const Duration(seconds: 3), () {
//       velocity = Vector2.zero();
//       rockyMoon.startSpinning();
//       thrustingUp = false;
//       isUnderUserControlledThrust = true;
//
//       engageShield();
//       bobInPlace();
//
//       gameRef.alertUserToRadioForeman();
//     });
//   }
//
//   void bobInPlace() {
//     final ec = RepeatedEffectController(SineEffectController(period: 2), 5);
//     final effect = MoveByEffect(Vector2(0, 10), ec);
//     add(effect);
//   }
//
//   @override
//   void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
//     super.onCollision(intersectionPoints, other);
//     if (other is AstronautOutdoorCharacterPart) {
//       isTouchedByAstronaut = true;
//       add(enterSpaceShipText);
//       game.canGuyEnterShip = true;
//     }
//   }
//
//   @override
//   void onCollisionEnd(PositionComponent other) {
//     super.onCollisionEnd(other);
//     if (other is AstronautOutdoorCharacterPart) {
//       remove(enterSpaceShipText);
//       game.canGuyEnterShip = false;
//     }
//   }
//
//   void thrustDown() {
//     final thrustDirection = Vector2(0, -1).normalized();
//     velocity = thrustDirection * thrustPower;
//     thrustAngle = 0;
//     sprayParticlesBack(0);
//   }
//
//   void thrustUp() {
//     final thrustDirection = Vector2(0, 1).normalized();
//     velocity = thrustDirection * thrustPower;
//     thrustAngle = pi;
//     sprayParticlesBack(0);
//   }
//
//   void thrustLeft() {
//     final thrustDirection = Vector2(-1, 0).normalized();
//     velocity = thrustDirection * thrustPower;
//     thrustAngle = -pi / 2;
//     sprayParticlesBack(0);
//   }
//
//   void thrustRight() {
//     final thrustDirection = Vector2(1, 0).normalized();
//     velocity = thrustDirection * thrustPower;
//     thrustAngle = pi / 2;
//     sprayParticlesBack(0);
//   }
//
//   void cutThrust() {
//     velocity = Vector2.zero();
//     bobInPlace();
//   }
//
//   void engageShield() {
//     shield.engage();
//   }
// }
