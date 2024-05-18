import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gravity_guy/planet.dart';

import 'astronaut.dart';

void main() {
  final game = GravityGuyGame();
  runApp(GameWidget(game: game));
}

class GravityGuyGame extends FlameGame
    with KeyboardEvents, HasCollisionDetection {
  static const double starterPlanetRadius = 250.00;
  static const double starterPlanetMass = 10000; // KG ??
  @override
  Future<void> onLoad() async {
    await Flame.images.load('astronaut3.png');
    final planet = Planet(
      radius: starterPlanetRadius,
      mass: starterPlanetMass,
      offset: const Offset(0, 0),
      positionVector: Vector2(500, 500),
    );

    world.add(planet);

    final astronaut = Astronaut();
    world.add(astronaut);

    camera.viewfinder.visibleGameSize = Vector2(1000, 1000);
    camera.viewfinder.position = Vector2(500, 500);
    camera.viewfinder.anchor = Anchor.center;
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is KeyDownEvent;
    final isKeyUp = event is KeyUpEvent;

    final isArrowRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isArrowLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final wasArrowRight = event.logicalKey == LogicalKeyboardKey.arrowRight;
    final wasArrowLeft = event.logicalKey == LogicalKeyboardKey.arrowLeft;
    final wasKeySpace = event.logicalKey == LogicalKeyboardKey.space;

    /// Player presses down the right arrow key
    /// The astronaut bounds to the right if it is touching the planet
    if (isArrowRight && isKeyDown) {
      // astronaut is walking
      final astronaut = world.children.firstWhere(
        (element) => element is Astronaut,
      ) as Astronaut;

      if (astronaut.orientedDirection == SpriteOrientedDirection.left) {
        astronaut.changeDirection(SpriteOrientedDirection.right);
      }
      astronaut.isWalking = true;

      if (astronaut.astronautIsTouchingPlanet) {
        astronaut.boundInDirection(BoundingDirection.right);
      }
      return KeyEventResult.handled;
    }

    /// Player presses down the left arrow key
    /// The astronaut bounds to the left if it is touching the planet
    if (isKeyDown && isArrowLeft) {
      final astronaut = world.children.firstWhere(
        (element) => element is Astronaut,
      ) as Astronaut;
      if (astronaut.orientedDirection == SpriteOrientedDirection.right) {
        astronaut.changeDirection(SpriteOrientedDirection.left);
      }
      astronaut.isWalking = true;

      if (astronaut.astronautIsTouchingPlanet) {
        astronaut.boundInDirection(BoundingDirection.left);
      }
      return KeyEventResult.handled;
    }

    if (wasKeySpace && isKeyDown) {
      final astronaut = world.children.firstWhere(
        (element) => element is Astronaut,
      ) as Astronaut;
      astronaut.jump();
      return KeyEventResult.handled;
    }

    if (wasArrowRight && isKeyUp) {
      final astronaut = world.children.firstWhere(
        (element) => element is Astronaut,
      ) as Astronaut;
      astronaut.isWalking = false;

      return KeyEventResult.handled;
    }

    /// Player presses down the left arrow key
    /// The astronaut bounds to the left if it is touching the planet
    if (isKeyDown && isArrowLeft) {
      final astronaut = world.children.firstWhere(
        (element) => element is Astronaut,
      ) as Astronaut;
      if (astronaut.orientedDirection == SpriteOrientedDirection.right) {
        astronaut.changeDirection(SpriteOrientedDirection.left);
      }
      astronaut.isWalking = true;

      if (astronaut.astronautIsTouchingPlanet) {
        astronaut.boundInDirection(BoundingDirection.left);
      }
      return KeyEventResult.handled;
    }

    if (isKeyUp && wasArrowLeft) {
      final astronaut = world.children.firstWhere(
        (element) => element is Astronaut,
      ) as Astronaut;
      astronaut.isWalking = false;
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
