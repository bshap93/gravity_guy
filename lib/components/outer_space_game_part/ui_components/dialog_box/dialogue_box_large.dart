import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:gravity_guy/components/outer_space_game_part/ui_components/dialog_box/script_dialog_interaction.dart';
import 'package:gravity_guy/game_parts/outer_space_game_part.dart';

import 'character_avatar.dart';
import 'continue_button_component.dart';
import 'exit_dialogue_button.dart';

class DialogueBoxLarge extends PositionComponent
    with HasGameRef<OuterSpaceGamePart>, TapCallbacks {
  late ExitDialogueButton exitDialogueButton;
  late SpriteComponent boxForDialogue;
  late Sprite boxSprite;
  late CharacterAvatar characterAvatar;
  late CharacterAvatar npcAvatar;
  late SpriteComponent avatarBackdrop;
  List<ScriptDialogInteraction> scriptDialogInteraction = [];

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

    scriptDialogInteraction.add(ScriptDialogInteraction(
        text: 'I just received word from the folks in Ad Hoc 37. '
            'Their attitude thrusters are acting up and they insist on '
            'remaining outside the core of the fleet, and refuse to let '
            'us retrofit their ships with swarm collective AI units.'));

    scriptDialogInteraction.add(ScriptDialogInteraction(
        text: 'Now they call me up, hysterical and demanding our help. '
            'I told \' em you\'d do it if they make it worth your while. '
            '1000 Iridium credits.'));

    add(ContinueButtonComponent(
      position: Vector2(0, 200),
      size: Vector2(150, 50),
      anchor: Anchor.center,
      onTap: () async {
        gameRef.exitDialogue();
        gameRef.beginDebrisGathering();
      },
    ));

    add(scriptDialogInteraction.first);

    add(boxForDialogue);

    add(exitDialogueButton);

    add(characterAvatar);
    add(npcAvatar);
  }
}
