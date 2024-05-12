import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gravity_guy/main.dart';

class Astronaut extends SpriteAnimationComponent
    with HasGameRef<GravityGuyGame>, KeyboardHandler {
  Astronaut()
      : super(
          size: Vector2(50, 50),
          anchor: Anchor.center,
        );

  bool isWalking = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
        'astronaut3.png',
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(29, 37),
        ));

    // sprite = await gameRef.loadSprite('astronaut3.png');
    position = Vector2(500, 225);
    playing = false;
    // stop animation
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isWalking) {
      playing = true;
    } else {
      playing = false;
    }
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.arrowDown) {
        playing = true;
      }
    }
  }

  // @override
  // KeyEventResult onKeyEvent(
  //     KeyEvent event,
  //     Set<LogicalKeyboardKey> keysPressed,
  // ) {

  // }
}
