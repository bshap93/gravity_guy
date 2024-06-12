import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';

import 'game_parts/outer_space_game_part.dart';

class HUDComponent extends PositionComponent
    with TapCallbacks, HasGameRef<OuterSpaceGamePart> {
  HUDComponent({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 15,
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
      boxConfig: const TextBoxConfig(timePerChar: 0.05),
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
    if (gameRef.isSoundEnabled) {
      playBeepsForText(currentDialogText);
    }
  }

  Future<void> playBeepsForText(String text) async {
    final audioPlayer = await FlameAudio.loop('beep.mp3');
    final textLength = text.length;
    final Duration textTypeTime = Duration(milliseconds: textLength * 50);
    await Future.delayed(textTypeTime, () => audioPlayer.stop());
  }

  void updateMessage(String s) {
    remove(currentDialogComponent);
    currentDialogComponent = TextBoxComponent(
        boxConfig: const TextBoxConfig(timePerChar: 0.05),
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
    if (gameRef.isSoundEnabled) {
      playBeepsForText(s);
    }
  }
}
