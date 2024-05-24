import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../inherited_components/astronaut.dart';
import 'map_proxima_space_station.dart';

class AstronautIndoorTopDownCharacterPart extends Astronaut {
  AstronautIndoorTopDownCharacterPart({required this.startingPosition})
      : super(
          hitBoxRadius: 32,
        );

  final Vector2 startingPosition;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = startingPosition;
    // velocity = Vector2(0, 100);
    // velocity = Vector2(-100, 0);
    velocity = Vector2.zero();

    size = Vector2(32, 32);

    add(RectangleHitbox(
      size: Vector2(64, 84),
      position: Vector2(0, 0),
      anchor: Anchor.center,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    // position += velocity * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is MapProximaSpaceStation) {
      velocity = Vector2.zero();
    }
  }
}
