import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../../../game_parts/outer_space_game_part.dart';

class CharacterAvatar extends SpriteAnimationComponent
    with HasGameRef<OuterSpaceGamePart> {
  CharacterAvatar({
    required this.isPlayerAvatar,
    required this.srcPath,
    required this.positionVar,
  });

  late SpriteAnimation playerAvatarAnimation;
  late SpriteAnimation npcAvatarAnimation;

  late SpriteSheet playerSpriteSheet;
  late SpriteSheet npcSpriteSheet;

  final bool isPlayerAvatar;
  final String srcPath;
  final Vector2 positionVar;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = positionVar;
    priority = 15;

    size = Vector2(32, 19) * 3;
    playerSpriteSheet = SpriteSheet(
      image: await gameRef.images.load(srcPath),
      srcSize: Vector2(32, 19),
    );

    playerAvatarAnimation = SpriteAnimation.fromFrameData(
        playerSpriteSheet.image,
        SpriteAnimationData([
          playerSpriteSheet.createFrameData(0, 0, stepTime: 0.3),
          playerSpriteSheet.createFrameData(0, 1, stepTime: 0.3),
        ]));

    animation = playerAvatarAnimation;
  }
}
