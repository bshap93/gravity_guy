import 'package:flame/components.dart';

class BodyWithMass extends SpriteAnimationComponent {
  BodyWithMass({
    required this.mass,
    required this.velocity,
    required this.acceleration,
    required this.anchor,
  }) : super(
          position: Vector2(0, 0),
          angle: 0,
          anchor: anchor,
        );
  double mass;
  Vector2 velocity;
  Vector2 acceleration;
  @override
  Anchor anchor;
}
