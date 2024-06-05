import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import '../../../../game_parts/outer_space_game_part.dart';

class ContinueButtonComponent extends PositionComponent
    with TapCallbacks, HasGameRef<OuterSpaceGamePart> {
  final Anchor anchor;
  final Function onTap;

  ContinueButtonComponent({
    required Vector2 position,
    required Vector2 size,
    required this.anchor,
    required this.onTap,
  }) : super(
          size: size,
          position: position,
          anchor: anchor,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final image = await Flame.images.load('ui_elements/button_small_cut1.png');

    Sprite continueButtonSprite = Sprite(image);

    priority = 20;

    add(SpriteComponent(
      size: size,
      anchor: anchor,
      sprite: continueButtonSprite,
    ));

    TextStyle? style = const TextStyle(
      color: Colors.black,
      fontSize: 20,
    );

    add(TextComponent(
      text: 'Continue',
      priority: priority + 1,
      position: Vector2(0, 0),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: style,
      ),
    ));
  }

  @override
  Future<void> onTapDown(TapDownEvent event) async {
    super.onTapDown(event);
    onTap();
  }
}
