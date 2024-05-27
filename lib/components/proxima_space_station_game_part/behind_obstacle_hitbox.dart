import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class BehindObstacleArea extends PositionComponent {
  BehindObstacleArea({
    required Vector2 size,
    required Vector2 position,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  void onLoad() {
    super.onLoad();
    add(
      RectangleHitbox(
        size: size,
        position: position,
        anchor: Anchor.center,
      ),
    );
  }
}
