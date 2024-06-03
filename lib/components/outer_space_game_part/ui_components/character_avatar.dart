import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../../../game_parts/outer_space_game_part.dart';

class CharacterAvatar extends SpriteAnimationComponent
    with HasGameRef<OuterSpaceGamePart> {
  CharacterAvatar({required bool isPlayerAvatar})
      : super(
        // anchor: Anchor.center,
        // position: Vector2(200, -220),
        // size: Vector2(24, 24),
        // angle: 0,
        // anchor: Anchor.center,
        // position: Vector2(200, -220),
        // size: Vector2(24, 24),
        // angle: 0,
        );
  late SpriteAnimation playerAvatarAnimation;
  late SpriteAnimation npcAvatarAnimation;

  late SpriteSheet playerSpriteSheet;
  late SpriteSheet npcSpriteSheet;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // if (isPlayerAvatar) {
    //   await loadPlayerAvatar();
    // } else {
    //   await loadNpcAvatar();
    // }
    position = Vector2(0, -180);
    size = Vector2(32, 19) * 3;
    playerSpriteSheet = SpriteSheet(
      image: await gameRef.images
          .load('character_dialog_avatars/astronaut4_talking_head.png'),
      srcSize: Vector2(32, 19),
    );

    npcSpriteSheet = SpriteSheet(
      image: await gameRef.images
          .load('character_dialog_avatars/other_astronaut_01.png'),
      srcSize: Vector2(32, 19),
    );

    playerAvatarAnimation = SpriteAnimation.fromFrameData(
        playerSpriteSheet.image,
        SpriteAnimationData([
          playerSpriteSheet.createFrameData(0, 0, stepTime: 0.3),
          playerSpriteSheet.createFrameData(0, 1, stepTime: 0.3),
        ]));

    npcAvatarAnimation = SpriteAnimation.fromFrameData(
        npcSpriteSheet.image,
        SpriteAnimationData([
          npcSpriteSheet.createFrameData(0, 0, stepTime: 0.3),
          npcSpriteSheet.createFrameData(0, 1, stepTime: 0.3),
        ]));

    animation = playerAvatarAnimation;
  }
}
