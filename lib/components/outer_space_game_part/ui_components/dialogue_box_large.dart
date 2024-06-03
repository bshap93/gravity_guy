import 'package:flame/components.dart';
import 'package:gravity_guy/game_parts/outer_space_game_part.dart';

import 'character_avatar.dart';
import 'exit_dialogue_button.dart';

class DialogueBoxLarge extends PositionComponent
    with HasGameRef<OuterSpaceGamePart> {
  late ExitDialogueButton exitDialogueButton;
  late SpriteComponent boxForDialogue;
  late Sprite boxSprite;
  late CharacterAvatar characterAvatar;
  late CharacterAvatar npcAvatar;

  DialogueBoxLarge()
      : super(
          size: Vector2(800, 500),
          anchor: Anchor.center,
          position: Vector2(1100, 600),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    exitDialogueButton = ExitDialogueButton();

    boxSprite = await Sprite.load(
      'dialog_box_large.png',
      srcSize: Vector2(800, 500),
    );

    boxForDialogue = SpriteComponent(
      size: Vector2(800, 500),
      anchor: Anchor.center,
      sprite: boxSprite,
    );

    characterAvatar = CharacterAvatar(isPlayerAvatar: true);
    npcAvatar = CharacterAvatar(isPlayerAvatar: false);

    add(boxForDialogue);

    add(exitDialogueButton);

    add(characterAvatar);
  }
}
