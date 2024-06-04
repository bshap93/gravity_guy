import 'package:flame/components.dart';

class ScriptDialogInteraction extends PositionComponent {
  final String text;

  ScriptDialogInteraction({required this.text})
      : super(
          size: Vector2(100, 50),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 15;

    final scriptDialogSpriteComponent = SpriteComponent(
      size: Vector2(100, 50),
      anchor: Anchor.center,
      sprite:
          await Sprite.load('assets/images/ui_elements/dialog_box-teal.png'),
    );

    add(scriptDialogSpriteComponent);
  }
}
