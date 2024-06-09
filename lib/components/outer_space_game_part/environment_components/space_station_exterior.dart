import 'package:flame/components.dart';

class SpaceStationExterior extends SpriteComponent {
  SpaceStationExterior()
      : super(
            size: Vector2(
          512,
          1024,
        ));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    angle = 0.24;

    position = Vector2(175, 1500);
    final spaceStationSprite = await Sprite.load('space_station_exterior.png');

    sprite = spaceStationSprite;
  }
}
