import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/parallax.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class PhysicsExpermental extends Forge2DGame {
  double zoomMultiplier = 1.0;
  bool debugMode = true;
  Ball ball = Ball();
  @override
  void onLoad() {
    super.onLoad();

    world.gravity = Vector2(0, 50);

    debugMode = debugMode;
    world.add(ball);

    add(BackgroundTexture());

    camera.viewfinder.visibleGameSize = Vector2(1000, 1000) * zoomMultiplier;
    // camera.follow(ball);

    world.add(
      Wall(
        position_: Vector2(
          -250,
          0,
        ),
        width_: 1,
        height_: 500,
        angle_: 0,
      ),
    );

    world.add(
      Wall(
        position_: Vector2(
          250,
          0,
        ),
        width_: 1,
        height_: 500,
        angle_: 0,
      ),
    );

    world.add(
      Wall(
        position_: Vector2(
          0,
          250,
        ),
        width_: 500,
        height_: 1,
        angle_: 0,
      ),
    );

    world.add(
      Wall(
        position_: Vector2(
          0,
          -250,
        ),
        width_: 500,
        height_: 1,
        angle_: 0,
      ),
    );
  }
}

class Ball extends BodyComponent with TapCallbacks, ContactCallbacks {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 1;
    body = world.createBody(
        BodyDef(position: Vector2(0.0, 0.0), type: BodyType.dynamic));

    bodyDef = BodyDef(
        position: Vector2(0.0, 0.0),
        type: BodyType.dynamic,
        linearVelocity: Vector2(0.0, 0.0));
    add(SpriteComponent(
      size: Vector2.all(100),
      sprite: await Sprite.load('effects/spr_shield.png'),
    ));
  }

  @override
  void onTapDown(TapDownEvent event) {
    // TODO: implement onTapDown
    print('Tapped');
  }

  @override
  void beginContact(Object other, Contact contact) {
    // TODO: implement beginContact
    super.beginContact(other, contact);
    if (other is Wall) {
      bounce();
    }
  }

  void bounce() {
    body.applyLinearImpulse(Vector2(0, -1000),
        point: body.worldCenter, wake: true);
  }
}

class BackgroundTexture extends ParallaxComponent<PhysicsExpermental> {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = -1;

    parallax = await game.loadParallax([
      ParallaxImageData('stony_wall.png'),
    ]);
  }
}

class Wall extends BodyComponent {
  Wall({
    required this.position_,
    required this.width_,
    required this.height_,
    required this.angle_,
  });

  final Vector2 position_;
  final double width_;
  final double height_;
  final double angle_;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    body = world.createBody(BodyDef(
      position: position_,
      type: BodyType.static,
      angle: angle_,
    ));

    final shape = PolygonShape();

    shape.setAsBox(width_, height_, position_, angle_);

    body.createFixtureFromShape(shape);
  }
}
