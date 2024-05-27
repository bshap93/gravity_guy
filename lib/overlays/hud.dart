import 'dart:ui';

import 'package:flame/components.dart';

import '../game_parts/outer_space_game_part.dart';

class Hud extends PositionComponent with HasGameRef<OuterSpaceGamePart> {
  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  });

  late SpriteComponent dialogBoxComponent;

  late String currentDialogText;

  late TextComponent currentDialogComponent;

  @override
  void onLoad() async {
    super.onLoad();
    currentDialogText =
        "Make your way to the space ship. Press left or right arrow to bound across the moon.";
    dialogBoxComponent = SpriteComponent(
      size: Vector2(800, 100),
      position: Vector2(600, 50),
      sprite: await Sprite.load('dialog_box.png'),
      anchor: Anchor.center,
    );
    add(dialogBoxComponent);
    currentDialogComponent = TextBoxComponent(
      text: currentDialogText,
      boxConfig: TextBoxConfig(timePerChar: 0.05),
      position: Vector2(625, 50),
      size: Vector2(600, 100),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: gameRef.mainTextFontStyle.copyWith(
          fontSize: 20,
        ),
      ),
    );
    add(currentDialogComponent);
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }

  void updateMessage(String s) {
    remove(currentDialogComponent);
    currentDialogComponent = TextBoxComponent(
        text: s,
        position: Vector2(625, 50),
        size: Vector2(600, 100),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: game.mainTextFontStyle.copyWith(
            fontSize: 20,
            color: const Color(0xFFD9BB26),
          ),
        ));
    add(currentDialogComponent);
  }
}