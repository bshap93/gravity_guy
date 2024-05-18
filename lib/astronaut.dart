import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gravity_guy/main.dart';
import 'package:gravity_guy/planet.dart';

enum SpriteOrientedDirection { left, right }

enum BoundingDirection { right, left }

class Astronaut extends SpriteAnimationComponent
    with HasGameRef<GravityGuyGame>, KeyboardHandler, CollisionCallbacks {
  bool isWalking = false;

  Vector2 accelerationDueToGravity = Vector2(0, 100);
  SpriteOrientedDirection orientedDirection = SpriteOrientedDirection.right;
  Vector2 velocity = Vector2.zero();
  // mass
  double mass = 1;

  // size of astronaut is 50x50

  Astronaut()
      : super(
          size: Vector2(50, 50),
          anchor: Anchor.center,
          position: Vector2(500, 225),
          angle: 0,
        );

  changeDirection(SpriteOrientedDirection direction) {
    if (direction == SpriteOrientedDirection.left &&
        orientedDirection == SpriteOrientedDirection.right) {
      orientedDirection = SpriteOrientedDirection.left;
      // flip sprite
      angle = 3.14;
      flipVertically();
    }

    if (direction == SpriteOrientedDirection.right &&
        orientedDirection == SpriteOrientedDirection.left) {
      orientedDirection = SpriteOrientedDirection.right;
      angle = 0;
      flipVertically();
    }
  }

  void jump() {
    // jump away from planet
    final planet = gameRef.world.children.firstWhere(
      (element) => element is Planet,
    ) as Planet;
    final direction = position - planet.position; // direction away from planet
    velocity = direction.normalized() * 100;
  }

  void boundInDirection(BoundingDirection boundingDirection) {
    final planet = gameRef.world.children.firstWhere(
      (element) => element is Planet,
    ) as Planet;

    jump();

    final gravityDirection = planet.position - position;

    // perpendicular direction
    final velocityChangeDirection = gravityDirection.perpendicular();

    if (boundingDirection == BoundingDirection.right) {
      velocity += velocityChangeDirection.normalized() * 100;
    }

    if (boundingDirection == BoundingDirection.left) {}
  }

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
    position = Vector2(500, 225);
    playing = false;
    // angle = 0;
    // stop animation
    add(RectangleHitbox(
      size: size,
      position: Vector2(0, 0),
      anchor: Anchor.topCenter,
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
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Planet) {
      final planet = other;

      velocity = Vector2.zero();

      // velocity -= direction.normalized() * velocity.length;

      // velocity = Vector2.zero();
      // set velocity with respect to planet to zero
      // calculate new velocity
      // final distance = planet.position - position;
      // final distanceMagnitude = distance.length;
      // final force =
      //     (1000 * mass * planet.mass) / (distanceMagnitude * distanceMagnitude);
      // final forceVector = distance.normalized() * force;
      // velocity = forceVector / mass;
    }
  }
}

extension Vector2Extension on Vector2 {
  Vector2 perpendicular() {
    return Vector2(-y, x);
  }
}
