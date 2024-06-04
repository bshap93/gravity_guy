import 'package:flame/components.dart';
import 'package:gravity_guy/components/outer_space_game_part/ui_components/script_dialog_interaction.dart';
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
  late SpriteComponent avatarBackdrop;
  late ScriptDialogInteraction scriptDialogInteraction;

  DialogueBoxLarge()
      : super(
          size: Vector2(1000, 500),
          anchor: Anchor.center,
          position: Vector2(1200, 600),
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

    characterAvatar = CharacterAvatar(
        isPlayerAvatar: true,
        srcPath: 'character_dialog_avatars/astronaut4_talking_head.png',
        positionVar: Vector2(-360, -180));

    npcAvatar = CharacterAvatar(
        isPlayerAvatar: false,
        srcPath: 'character_dialog_avatars/other_astronaut_01.png',
        positionVar: Vector2(0, -180));
    final avatarBackdropSprite =
        await Sprite.load('ui_elements/listbox_default.png');

    add(SpriteComponent(
      size: Vector2(200, 120),
      anchor: Anchor.center,
      sprite: avatarBackdropSprite,
      priority: 14,
      position: Vector2(-280, -170),
    ));

    add(SpriteComponent(
      size: Vector2(200, 120),
      anchor: Anchor.center,
      sprite: avatarBackdropSprite,
      priority: 14,
      position: Vector2(20, -170),
    ));

    scriptDialogInteraction = ScriptDialogInteraction(
      text:
          'You know the drill... get all the debris half a klick sunward. Stay safe!',
    );

    add(scriptDialogInteraction);

    add(boxForDialogue);

    add(exitDialogueButton);

    add(characterAvatar);
    add(npcAvatar);
  }
}
