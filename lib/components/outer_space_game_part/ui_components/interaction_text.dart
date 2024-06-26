import 'dart:ui';

import 'package:flame/components.dart';
import 'package:gravity_guy/game_parts/outer_space_game_part.dart';

class InteractionText extends TextComponent
    with HasGameRef<OuterSpaceGamePart> {
  InteractionText({
    required Vector2 positionVector,
    required String text,
    required double angle,
  }) : super(
            position: positionVector,
            text: text,
            anchor: Anchor.center,
            size: Vector2(50, 50),
            angle: angle);

  @override
  void onLoad() {
    super.onLoad();
    textRenderer = TextPaint(
      style: gameRef.mainTextFontStyle.copyWith(
        fontSize: 32,
      ),
      textDirection: TextDirection.ltr,
    );
  }
}
