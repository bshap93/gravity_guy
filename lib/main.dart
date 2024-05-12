import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gravity_guy/planet.dart';

import 'astronaut.dart';

void main() {
  final game = GravityGuyGame();
  runApp(GameWidget(game: game));
}

class GravityGuyGame extends FlameGame {
  static const double starterPlanetRadius = 250.00;
  static const double starterPlanetMass = 10000; // KG ??
  @override
  Future<void> onLoad() async {
    await Flame.images.load('astronaut3.png');
    final planet = Planet(
      radius: starterPlanetRadius,
      mass: starterPlanetMass,
      offset: const Offset(500, 500),
    );

    world.add(planet);

    final astronaut = Astronaut();
    world.add(astronaut);

    camera.viewfinder.visibleGameSize = Vector2(1000, 1000);
    camera.viewfinder.position = Vector2(500, 500);
    camera.viewfinder.anchor = Anchor.center;
  }
}
