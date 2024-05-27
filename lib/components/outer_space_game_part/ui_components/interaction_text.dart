import 'dart:ui';

import 'package:flame/components.dart';
import 'package:gravity_guy/game_parts/outer_space_game_part.dart';

class InteractionText extends TextComponent
    with HasGameRef<OuterSpaceGamePart> {
  InteractionText({
    required Vector2 positionVector,
    required String text,
  }) : super(
          text: text,
          anchor: Anchor.topRight,
        );

  @override
  void onLoad() {
    super.onLoad();
    textRenderer = TextPaint(
      style: gameRef.mainTextFontStyle.copyWith(
        fontSize: 18,
      ),
      textDirection: TextDirection.ltr,
    );
  }
}
