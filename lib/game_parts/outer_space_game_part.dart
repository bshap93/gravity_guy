import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../components/outer_space_game_part/controllable_components/astronaut_outdoor_character_part.dart';
import '../components/outer_space_game_part/controllable_components/space_ship.dart';
import '../components/outer_space_game_part/environment_components/planet.dart';

class OuterSpaceGamePart extends FlameGame
    with KeyboardEvents, HasCollisionDetection {
  static const double starterPlanetRadius = 250.00;
  static const double starterPlanetMass = 10000; // KG ??

  bool canGuyEnterShip = false;
  bool isGuyOutsideShip = true;
  bool onLoaded = false;

  @override
  Future<void> onLoad() async {
    await Flame.images.load('astronaut4.png');
    await Flame.images.load('planet1.png');
    await Flame.images.load('spaceShip1.png');
    await Flame.images.load('spr_stars02.png');
    await Flame.images.load('spr_stars01.png');

    final parallaxBackground1 = await loadParallaxComponent(
      [
        ParallaxImageData('spr_stars02.png'),
        ParallaxImageData('spr_stars01.png'),
      ],
      baseVelocity: Vector2(20, 0),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
      size: size * 3,
      anchor: Anchor.center,
      repeat: ImageRepeat.repeat,
    );

    final planet = Planet(
      radius: starterPlanetRadius,
      mass: starterPlanetMass,
      offset: const Offset(0, 0),
      positionVector: Vector2(500, 500),
    );

    world.add(parallaxBackground1);

    world.add(planet);

    final astronaut = AstronautOutdoorCharacterPart();
    world.add(astronaut);

    final spaceShip = SpaceShip();
    world.add(spaceShip);

    camera.viewfinder.visibleGameSize = Vector2(1000, 1000);
    camera.viewfinder.position = Vector2(500, 500);
    camera.viewfinder.anchor = Anchor.center;

    onLoaded = true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isGuyOutsideShip) {
      final spaceShip = world.children.firstWhere(
        (element) => element is SpaceShip,
      ) as SpaceShip;

      if (spaceShip.isOccupied) {
        camera.viewfinder.position = spaceShip.position;
      }

      final parallaxBackground1 = world.children.firstWhere(
        (element) => element is ParallaxComponent,
      ) as ParallaxComponent;

      /// The parallax background follows the space ship
      parallaxBackground1.position = spaceShip.position;
    }
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
    final isKeyX = keysPressed.contains(LogicalKeyboardKey.keyX);

    if (isKeyX && isKeyDown && canGuyEnterShip) {
      final astronaut = world.children.firstWhere(
        (element) => element is AstronautOutdoorCharacterPart,
      ) as AstronautOutdoorCharacterPart;
      world.remove(astronaut);

      final spaceShip = world.children.firstWhere(
        (element) => element is SpaceShip,
      ) as SpaceShip;

      spaceShip.acceptAstronaut();
      camera.viewfinder.position = spaceShip.position;
      camera.viewfinder.angle = spaceShip.angle;

      spaceShip.blastOff();

      return KeyEventResult.handled;
    }

    /// Player presses down the right arrow key
    /// The astronaut bounds to the right if it is touching the planet
    if (isArrowRight && isKeyDown && isGuyOutsideShip) {
      // astronaut is walking
      final astronaut = world.children.firstWhere(
        (element) => element is AstronautOutdoorCharacterPart,
      ) as AstronautOutdoorCharacterPart;

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
    if (isKeyDown && isArrowLeft && isGuyOutsideShip) {
      final astronaut = world.children.firstWhere(
        (element) => element is AstronautOutdoorCharacterPart,
      ) as AstronautOutdoorCharacterPart;
      if (astronaut.orientedDirection == SpriteOrientedDirection.right) {
        astronaut.changeDirection(SpriteOrientedDirection.left);
      }
      astronaut.isWalking = true;

      if (astronaut.astronautIsTouchingPlanet) {
        astronaut.boundInDirection(BoundingDirection.left);
      }
      return KeyEventResult.handled;
    }

    if (wasKeySpace && isKeyDown && isGuyOutsideShip) {
      final astronaut = world.children.firstWhere(
        (element) => element is AstronautOutdoorCharacterPart,
      ) as AstronautOutdoorCharacterPart;
      astronaut.jumpAwayFromPlanet();
      return KeyEventResult.handled;
    }

    if (wasArrowRight && isKeyUp && isGuyOutsideShip) {
      final astronaut = world.children.firstWhere(
        (element) => element is AstronautOutdoorCharacterPart,
      ) as AstronautOutdoorCharacterPart;
      astronaut.isWalking = false;

      return KeyEventResult.handled;
    }

    /// Player presses down the left arrow key
    /// The astronaut bounds to the left if it is touching the planet
    if (isKeyDown && isArrowLeft && isGuyOutsideShip) {
      final astronaut = world.children.firstWhere(
        (element) => element is AstronautOutdoorCharacterPart,
      ) as AstronautOutdoorCharacterPart;
      if (astronaut.orientedDirection == SpriteOrientedDirection.right) {
        astronaut.changeDirection(SpriteOrientedDirection.left);
      }
      astronaut.isWalking = true;

      if (astronaut.astronautIsTouchingPlanet) {
        astronaut.boundInDirection(BoundingDirection.left);
      }
      return KeyEventResult.handled;
    }

    if (isKeyUp && wasArrowLeft && isGuyOutsideShip) {
      final astronaut = world.children.firstWhere(
        (element) => element is AstronautOutdoorCharacterPart,
      ) as AstronautOutdoorCharacterPart;
      astronaut.isWalking = false;
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
