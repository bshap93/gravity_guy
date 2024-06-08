import 'package:flame/components.dart';

class SpaceStationExterior extends SpriteComponent {
  SpaceStationExterior()
      : super(
            size: Vector2(
          256,
          512,
        ));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    angle = 0.2;
    size = Vector2(512, 1024);

    position = Vector2(200, 1700);
    final spaceStationSprite = await Sprite.load('space_station_exterior.png');

    sprite = spaceStationSprite;
  }
}
