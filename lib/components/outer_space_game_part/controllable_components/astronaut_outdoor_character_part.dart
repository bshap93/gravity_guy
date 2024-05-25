import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:gravity_guy/components/outer_space_game_part/environment_components/planet.dart';

import '../../../game_parts/outer_space_game_part.dart';

enum SpriteOrientedDirection { left, right }

enum BoundingDirection { right, left }

class AstronautOutdoorCharacterPart extends SpriteAnimationComponent
    with HasGameRef<OuterSpaceGamePart>, KeyboardHandler, CollisionCallbacks {
  bool isWalking = false;
  bool astronautIsTouchingPlanet = false;
  bool ignorePlanetCollision = false;

  Vector2 accelerationDueToGravity = Vector2(0, 100);
  SpriteOrientedDirection orientedDirection = SpriteOrientedDirection.right;
  Vector2 velocity = Vector2.zero();
  // mass
  Vector2 initialPosition = Vector2(500, 225);
  double boundingSpeed = 157;
  double walkingSpeed = 100;
  double jumpSpeed = 60;

  late SpriteSheet spriteSheet;
  late SpriteAnimation stationaryAnimation;

  // size of astronaut is 50x50

  AstronautOutdoorCharacterPart()
      : super(
          size: Vector2(50, 50),
          anchor: Anchor.center,
          angle: 0,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    spriteSheet = SpriteSheet(
      image: await gameRef.images.load('astronaut4.png'),
      srcSize: Vector2(32, 32),
    );

    stationaryAnimation = SpriteAnimation.fromFrameData(
        spriteSheet.image,
        SpriteAnimationData([
          spriteSheet.createFrameData(0, 0, stepTime: 0.3),
          spriteSheet.createFrameData(0, 1, stepTime: 0.3),
          spriteSheet.createFrameData(0, 2, stepTime: 0.3),
        ]));

    animation = stationaryAnimation;

    // sprite = await gameRef.loadSprite('astronaut3.png');
    position = initialPosition;
    playing = true;
    // angle = 0;
    // stop animation
    add(CircleHitbox(
      // This *2 was a sorta hack way to have him collide with the planet
      // at his feet, but it's not perfect.
      radius: 50,
      position: Vector2(0, 0),
      anchor: Anchor.center,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    // if (isWalking) {
    //   playing = false;
    //   // TODO - add walking animation
    //   // animation = walkingAnimation;
    // } else {
    //   playing = false;
    // }

    position += velocity * dt;

    final planet = gameRef.world.children.firstWhere(
      (element) => element is Planet,
    ) as Planet;

    final direction = planet.position - position;

    // velocity goes toward planet
    if (!ignorePlanetCollision) {
      accelerationDueToGravity = direction.normalized() * 100;
    } else {
      accelerationDueToGravity = Vector2.zero();
    }

    velocity += accelerationDueToGravity * dt;

    final newAngle = Vector2ToRadian(direction);

    angle = newAngle;
    game.camera.viewfinder.angle = newAngle;
  }

  changeDirection(SpriteOrientedDirection direction) {
    if (direction == SpriteOrientedDirection.left &&
        orientedDirection == SpriteOrientedDirection.right) {
      orientedDirection = SpriteOrientedDirection.left;
      flipHorizontally();
    }

    if (direction == SpriteOrientedDirection.right &&
        orientedDirection == SpriteOrientedDirection.left) {
      orientedDirection = SpriteOrientedDirection.right;
      flipHorizontally();
    }
  }

  void jumpAwayFromPlanet() {
    // jump away from planet
    final planet = gameRef.world.children.firstWhere(
      (element) => element is Planet,
    ) as Planet;
    final direction = position - planet.position; // direction away from planet
    velocity = direction.normalized() * jumpSpeed;
    ignorePlanetCollision = false;
  }

  void walkInDirection(BoundingDirection right) {
    // ignorePlanetCollision = true;
    final walkingAnimation = SpriteAnimation.fromFrameData(
        spriteSheet.image,
        SpriteAnimationData([
          spriteSheet.createFrameData(0, 0, stepTime: 0.3),
          spriteSheet.createFrameData(0, 1, stepTime: 0.3),
          spriteSheet.createFrameData(0, 2, stepTime: 0.3),
        ]));

    animation = walkingAnimation;

    final velocityChangeDirection = getVelocityChangeDirection();

    if (right == BoundingDirection.right) {
      velocity += velocityChangeDirection.normalized() * walkingSpeed * 2;
      position -= velocityChangeDirection.normalized().perpendicular() * 0.5;
    }
  }

  void boundInDirection(BoundingDirection boundingDirection) {
    ignorePlanetCollision = true;
    executePreJumpSequence(boundingDirection);

    Future.delayed(const Duration(milliseconds: 1000), () {
      jumpAwayFromPlanet();

      final duringJumpAnimation = SpriteAnimation.fromFrameData(
          spriteSheet.image,
          SpriteAnimationData([
            spriteSheet.createFrameData(0, 9, stepTime: 0.3),
            spriteSheet.createFrameData(0, 8, stepTime: 0.3),
          ]));

      animation = duringJumpAnimation;

      final velocityChangeDirection = getVelocityChangeDirection();

      if (boundingDirection == BoundingDirection.right) {
        velocity += velocityChangeDirection.normalized() * boundingSpeed;
      }

      if (boundingDirection == BoundingDirection.left) {
        velocity -= velocityChangeDirection.normalized() * boundingSpeed;
      }
    });
  }

  void executePreJumpSequence(BoundingDirection boundingDirection) {
    ignorePlanetCollision = true;
    final preJumpAnimation = SpriteAnimation.fromFrameData(
        spriteSheet.image,
        SpriteAnimationData([
          spriteSheet.createFrameData(0, 0, stepTime: 0.3),
          spriteSheet.createFrameData(0, 3, stepTime: 0.3),
          spriteSheet.createFrameData(0, 5, stepTime: 0.3),
          spriteSheet.createFrameData(0, 6, stepTime: 0.3),
          spriteSheet.createFrameData(0, 7, stepTime: 0.3),
          spriteSheet.createFrameData(0, 8, stepTime: 0.3),
          spriteSheet.createFrameData(0, 9, stepTime: 0.3),
        ]));

    animation = preJumpAnimation;

    // final gravityDirection = planet.position - position;
    final velocityChangeDirection = getVelocityChangeDirection();

    if (boundingDirection == BoundingDirection.right) {
      velocity += velocityChangeDirection.normalized() * 20;
    }

    if (boundingDirection == BoundingDirection.left) {
      velocity -= velocityChangeDirection.normalized() * 20;
    }
  }

  Vector2 getVelocityChangeDirection() {
    final planet = gameRef.world.children.firstWhere(
      (element) => element is Planet,
    ) as Planet;
    final gravityDirection = planet.position - position;

    // perpendicular direction
    return -(gravityDirection.perpendicular());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Planet) {
      if (!ignorePlanetCollision) {
        // velocity is ze
        velocity = Vector2.zero();
        animation = stationaryAnimation;
        astronautIsTouchingPlanet = true;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Planet) {
      astronautIsTouchingPlanet = false;
    }
  }
}

double Vector2ToRadian(Vector2 direction) {
  double angle = 2 * pi - atan2(direction.x, direction.y);
  return angle;
}

extension Vector2Extension on Vector2 {
  Vector2 perpendicular() {
    return Vector2(-y, x);
  }
}
