import 'dart:ui';

import 'package:flame/components.dart';
import 'package:google_fonts/google_fonts.dart';

class Hud extends PositionComponent {
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
    currentDialogText = "Make your way to the space ship. Press left or right arrow to bound across the moon.";
    dialogBoxComponent = SpriteComponent(
      size: Vector2(800, 100),
    position: Vector2(600, 50),
      sprite: await Sprite.load('dialog_box.png'),
      anchor: Anchor.center,
    );
    add(dialogBoxComponent);
    currentDialogComponent = TextBoxComponent(
      text: currentDialogText,
      position: Vector2(625, 50),
      size: Vector2(600, 100),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: GoogleFonts.getFont('Nabla').copyWith(
        color: const Color(0xFFD9BB26),
        fontSize: 24,
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
        style: GoogleFonts.getFont('Nabla').copyWith(
        color: const Color(0xFFD9BB26),
        fontSize: 24,
      ),

      ));
    add(currentDialogComponent);
  }
}