import 'package:flame/components.dart';

import '../main.dart';

class StarsParallaxBackground extends PositionComponent
    with HasGameRef<GravityGuyGame> {
  StarsParallaxBackground({
    required this.parallaxComponent,
  });

  final ParallaxComponent parallaxComponent;

  @override
  Future<void> onLoad() async {
    add(parallaxComponent);
  }
}
