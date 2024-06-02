import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gravity_guy/components/outer_space_game_part/environment_components/space_station_exterior.dart';

import '../components/inherited_components/game_part.dart';
import '../components/outer_space_game_part/controllable_components/astronaut_outdoor_character_part.dart';
import '../components/outer_space_game_part/controllable_components/space_ship.dart';
import '../components/outer_space_game_part/environment_components/planet.dart';
import '../hud.dart';

class OuterSpaceGamePart extends GamePart {
  static const double starterPlanetRadius = 350.00;
  static const double starterPlanetMass = 10000; // KG ??

  bool canGuyEnterShip = false;
  bool isGuyOutsideShip = true;
  bool onLoaded = false;
  bool guyCanInitiateDialogue = false;

  final pauseOverlayIdentifier = 'PauseMenu';
  final dialogueOverlayIdentifier = 'DialogueScreen';

  late HUDComponent hudComponent;
  late AstronautOutdoorCharacterPart astronaut;
  late SpaceShip spaceShip;

  TextStyle mainTextFontStyle // When using, specify fontsize with copyWith
      = GoogleFonts.getFont('Nabla').copyWith(
    color: const Color(0xFFD9BB26),
  );

  @override
  Future<void> onLoad() async {
    await Flame.images.load('astronaut4.png');
    await Flame.images.load('Lunar_03-512x512.png');
    await Flame.images.load('spr_stars02.png');
    await Flame.images.load('spr_stars01.png');
    await Flame.images.load('space_station_exterior.png');
    await Flame.images.load('ui_elements/button_x.png');

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

    astronaut =
        AstronautOutdoorCharacterPart(initialPosition: Vector2(500, 125));
    world.add(astronaut);

    spaceShip =
        SpaceShip(initialPosition: Vector2(1000, 1000), initialAngle: pi / 2);
    world.add(spaceShip);

    final spaceStationExterior = SpaceStationExterior();
    world.add(spaceStationExterior);

    hudComponent = HUDComponent();
    camera.viewport.add(hudComponent);

    // camera.viewfinder.visibleGameSize = Vector2(500, 500);
    camera.viewfinder.visibleGameSize = Vector2(1000, 1000);
    camera.follow(astronaut);
    // camera.viewfinder.position = Vector2(500, 225);
    camera.viewfinder.anchor = Anchor.center;

    onLoaded = true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isGuyOutsideShip) {
      // final spaceShip = world.children.firstWhere(
      //   (element) => element is SpaceShip,
      // ) as SpaceShip;

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

  void pauseGame(String overlayIdentifier) {
    overlays.add(pauseOverlayIdentifier);
    paused = true;
  }

  void unPauseGame(String overlayIdentifier) {
    overlays.remove(pauseOverlayIdentifier);
    paused = false;
  }

  void enterDialogue(String overlayIdentifier) {
    overlays.add(dialogueOverlayIdentifier);
    paused = false;
  }

  void exitDialogue(String overlayIdentifier) {
    overlays.remove(dialogueOverlayIdentifier);
    paused = false;
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
    final isKeyEsc = keysPressed.contains(LogicalKeyboardKey.escape);
    final isKeyC = keysPressed.contains(LogicalKeyboardKey.keyC);

    if (isKeyEsc && isKeyDown) {
      if (paused) {
        unPauseGame(pauseOverlayIdentifier);
      } else {
        pauseGame(pauseOverlayIdentifier);
      }
      return KeyEventResult.handled;
    }

    if (isKeyC && isKeyDown) {
      // enterDialogue(dialogueOverlayIdentifier);
      return KeyEventResult.handled;
    }

    if (isKeyX && isKeyDown && canGuyEnterShip) {
      world.remove(astronaut);

      spaceShip.acceptAstronaut();
      camera.viewfinder.position = spaceShip.position;
      camera.viewfinder.angle = spaceShip.angle;

      spaceShip.blastOff();

      return KeyEventResult.handled;
    }

    /// Player presses down the right arrow key
    /// The astronaut bounds to the right if it is touching the planet
    if (isArrowRight && isGuyOutsideShip) {
      boundRightOverview();
      // walkRightOverview();
      //
      return KeyEventResult.handled;
    }

    /// Player presses down the left arrow key
    /// The astronaut bounds to the left if it is touching the planet
    if (isKeyDown && isArrowLeft && isGuyOutsideShip) {
      boundLeftOverview();
      return KeyEventResult.handled;
    }

    /// Player presses down the space key
    if (wasKeySpace && isKeyDown && isGuyOutsideShip) {
      astronaut.jumpAwayFromPlanet();
      return KeyEventResult.handled;
    }

    if (wasArrowRight && isKeyUp && isGuyOutsideShip) {
      astronaut.isWalking = false;

      return KeyEventResult.handled;
    }

    /// Player presses down the left arrow key
    /// The astronaut bounds to the left if it is touching the planet
    if (isKeyDown && isArrowLeft && isGuyOutsideShip) {
      boundLeftOverview();
      return KeyEventResult.handled;
    }

    if (isKeyUp && wasArrowLeft && isGuyOutsideShip) {
      astronaut.isWalking = false;
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void boundRightOverview() {
    // astronaut is walking

    if (astronaut.orientedDirection == SpriteOrientedDirection.left) {
      astronaut.changeDirection(SpriteOrientedDirection.right);
    }
    astronaut.isWalking = true;

    if (astronaut.astronautIsTouchingPlanet) {
      astronaut.boundInDirection(BoundingDirection.right);
    }
  }

  void boundLeftOverview() {
    // astronaut is walking

    if (astronaut.orientedDirection == SpriteOrientedDirection.right) {
      astronaut.changeDirection(SpriteOrientedDirection.left);
    }
    astronaut.isWalking = true;

    if (astronaut.astronautIsTouchingPlanet) {
      astronaut.boundInDirection(BoundingDirection.left);
    }
  }
}
