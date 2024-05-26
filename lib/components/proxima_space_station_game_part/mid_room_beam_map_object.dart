import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class MidRoomBeamMapObject extends PositionComponent {
  MidRoomBeamMapObject({
    required this.tileObject,
    required this.objectWidth,
    required this.objectHeight,
  });

  late CompositeHitbox midRoomBeamHitbox;
  final TiledComponent tileObject;
  final double objectWidth;
  final double objectHeight;
  @override
  void onLoad() {
    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
