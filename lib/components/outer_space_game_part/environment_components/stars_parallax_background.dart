import 'package:flame/components.dart';

import '../../../game_parts/outer_space_game_part.dart';

class StarsParallaxBackground extends PositionComponent
    with HasGameRef<OuterSpaceGamePart> {
  StarsParallaxBackground({
    required this.parallaxComponent,
  });

  final ParallaxComponent parallaxComponent;

  @override
  Future<void> onLoad() async {
    add(parallaxComponent);
  }
}
