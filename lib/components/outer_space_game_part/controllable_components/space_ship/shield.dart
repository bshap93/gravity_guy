import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

enum ShieldType { defaultShield }

class Shield extends SpriteComponent with CollisionCallbacks {
  final double ellipseHeight;
  final double ellipseWidth;
  final ShieldType shieldType;
  Shield({
    required Vector2 position,
    required this.ellipseHeight,
    required this.ellipseWidth,
    this.shieldType = ShieldType.defaultShield,
  }) {
    anchor = Anchor.center;
    this.position = position;
  }

  @override
  Future<void> onLoad() async {
    width = ellipseWidth;
    height = ellipseHeight;
    opacity = 0;

    await super.onLoad();
    final shieldSprite = await Sprite.load('effects/spr_shield.png');

    sprite = shieldSprite;

    add(CircleHitbox(
      radius: ellipseHeight / 2,
    ));
  }

  void engage() {
    final effect =
        OpacityEffect.to(1, EffectController(duration: 0.75), target: this);
    add(effect);
    Future.delayed(const Duration(seconds: 1), () {
      final effect2 =
          OpacityEffect.to(0, EffectController(duration: 0.75), target: this);
      add(effect2);
    });
  }
}
