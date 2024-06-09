import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class Shield extends SpriteComponent with CollisionCallbacks {
  Shield({required Vector2 position}) {
    width = 250;
    height = 250;
    anchor = Anchor.center;
    this.position = position;
  }

  @override
  Future<void> onLoad() async {
    opacity = 0;

    await super.onLoad();
    final shieldSprite = await Sprite.load('effects/spr_shield.png');

    sprite = shieldSprite;

    add(CircleHitbox(
      radius: 120,
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
