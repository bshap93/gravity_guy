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

    position = Vector2(512, 1500);
    final spaceStationSprite = await Sprite.load('space_station_exterior.png');

    sprite = spaceStationSprite;

    final spaceStation =
        SpriteComponent(size: Vector2(100, 100), sprite: spaceStationSprite);

    add(spaceStation);
  }
}
