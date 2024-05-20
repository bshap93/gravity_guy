import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gravity_guy/environment_components/planet.dart';
import 'package:gravity_guy/main.dart';

enum SpriteOrientedDirection { left, right }

enum BoundingDirection { right, left }

class Astronaut extends SpriteAnimationComponent
    with HasGameRef<GravityGuyGame>, KeyboardHandler, CollisionCallbacks {
  bool isWalking = false;
  bool astronautIsTouchingPlanet = false;

  Vector2 accelerationDueToGravity = Vector2(0, 100);
  SpriteOrientedDirection orientedDirection = SpriteOrientedDirection.right;
  Vector2 velocity = Vector2.zero();
  // mass
  Vector2 initialPosition = Vector2(500, 225);
  double boundingSpeed = 165;
  double jumpSpeed = 60;

  // size of astronaut is 50x50

  Astronaut()
      : super(
          size: Vector2(50, 50),
          anchor: Anchor.center,
          angle: 0,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
        'astronaut3.png',
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(29, 37),
        ));

    // sprite = await gameRef.loadSprite('astronaut3.png');
    position = initialPosition;
    playing = false;
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
    if (isWalking) {
      playing = true;
    } else {
      playing = false;
    }

    position += velocity * dt;

    final planet = gameRef.world.children.firstWhere(
      (element) => element is Planet,
    ) as Planet;

    final direction = planet.position - position;

    // velocity goes toward planet
    accelerationDueToGravity = direction.normalized() * 100;

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

  void jump() {
    // jump away from planet
    final planet = gameRef.world.children.firstWhere(
      (element) => element is Planet,
    ) as Planet;
    final direction = position - planet.position; // direction away from planet
    velocity = direction.normalized() * jumpSpeed;
  }

  void boundInDirection(BoundingDirection boundingDirection) {
    final planet = gameRef.world.children.firstWhere(
      (element) => element is Planet,
    ) as Planet;

    jump();

    final gravityDirection = planet.position - position;

    // perpendicular direction
    final velocityChangeDirection = -(gravityDirection.perpendicular());

    if (boundingDirection == BoundingDirection.right) {
      velocity += velocityChangeDirection.normalized() * boundingSpeed;
    }

    if (boundingDirection == BoundingDirection.left) {
      velocity -= velocityChangeDirection.normalized() * boundingSpeed;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Planet) {
      velocity = Vector2.zero();
      astronautIsTouchingPlanet = true;
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
