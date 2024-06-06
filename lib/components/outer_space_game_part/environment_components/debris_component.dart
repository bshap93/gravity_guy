import 'package:flame/components.dart';

const double debrisSize = 32;

class DebrisComponent extends SpriteComponent {
  DebrisComponent({
    required this.srcPath,
    required this.positionVar,
    required this.debrisSize,
    required this.startingAngle,
    required this.angleVelocity,
  });

  final String srcPath;
  final Vector2 positionVar;
  final Vector2 debrisSize;
  final double startingAngle;
  final double angleVelocity;

  @override
  Future<void> onLoad() async {
    priority = 5;
    anchor = Anchor.center;
    super.onLoad();
    final debrisSprite = await Sprite.load(srcPath);
    sprite = debrisSprite;
    position = positionVar;
    size = debrisSize;
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle += angleVelocity * dt;
  }
}
