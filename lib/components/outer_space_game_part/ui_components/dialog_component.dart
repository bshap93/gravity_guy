import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../../../game_parts/outer_space_game_part.dart';

class DialogComponent extends PositionComponent
    with HasGameRef<OuterSpaceGamePart> {
  late TextComponent currentDialogComponent;
  DialogComponent({
    required String text,
    required Vector2 position,
    required Vector2 size,
    required this.initialText,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  final String initialText;

  @override
  void onLoad() {
    super.onLoad();
    currentDialogComponent = TextComponent(
      text: initialText,
      position: Vector2(0, 0),
      size: size,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: gameRef.mainTextFontStyle.copyWith(
          fontSize: 20,
        ),
      ),
    );

    playBeepsForText(initialText);
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
