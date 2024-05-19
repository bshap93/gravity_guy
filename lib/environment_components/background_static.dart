import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import '../main.dart';

class BackgroundStatic extends SpriteComponent with HasGameRef<GravityGuyGame> {
  @override
  Future<void> onLoad() async {
    add(SpriteComponent(
      sprite: Sprite(await Flame.images.load('spr_stars02.png')),
      anchor: Anchor.center,
      size: gameRef.size,
    ));
  }
}
