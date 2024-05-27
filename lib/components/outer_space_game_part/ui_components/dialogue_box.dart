import 'package:flame/components.dart';

class DialogueBoxComponent extends PositionComponent {
  @override
  void onLoad() async {
    super.onLoad();
    priority = 20;
    final dialogBoxImage = await Sprite.load('dialog_box.png');
    add(SpriteComponent(
      size: Vector2(800, 100),
      position: Vector2(500, 1000),
      sprite: dialogBoxImage,
      anchor: Anchor.bottomCenter,
    ));
  }
}
