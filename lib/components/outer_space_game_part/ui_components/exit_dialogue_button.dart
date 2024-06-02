import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:gravity_guy/game_parts/outer_space_game_part.dart';

late SpriteAnimation idleExitDialogueButtonAnimation;

class ExitDialogueButton extends SpriteAnimationComponent
    with TapCallbacks, HasGameRef<OuterSpaceGamePart> {
  ExitDialogueButton()
      : super(
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(940, 185);
    priority = 12;
    anchor = Anchor.center;
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('ui_elements/button_x.png'),
      srcSize: Vector2(24, 24),
    );

    idleExitDialogueButtonAnimation = SpriteAnimation.fromFrameData(
        spriteSheet.image,
        SpriteAnimationData([
          spriteSheet.createFrameData(0, 0, stepTime: 0.3),
        ]));

    animation = idleExitDialogueButtonAnimation;

    size = Vector2(24, 24);
  }
}
