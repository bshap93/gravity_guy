import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../../../game_parts/outer_space_game_part.dart';

class ScriptDialogInteraction extends PositionComponent
    with HasGameRef<OuterSpaceGamePart> {
  final String text;

  late TextComponent currentDialogComponent;

  late String currentDialogText;

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
      size: Vector2(500, 200),
      position: Vector2(-40, 40),
      anchor: Anchor.center,
      sprite: await Sprite.load('ui_elements/dialog_box-teal.png'),
    );

    // currentDialogText =
    //     "Make your way to the space ship. Press left or right arrow to bound across the moon.";
    add(scriptDialogSpriteComponent);
    currentDialogComponent = TextBoxComponent(
      text: text,
      boxConfig: const TextBoxConfig(timePerChar: 0.05),
      position: Vector2(0, 80),
      size: Vector2(500, 100),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: gameRef.mainTextFontStyle
            .copyWith(fontSize: 20, color: Colors.black),
      ),
    );
    add(currentDialogComponent);
    playBeepsForText(text);
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
    playBeepsForText(s);
  }
}
