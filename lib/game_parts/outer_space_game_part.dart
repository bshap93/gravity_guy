import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../components/inherited_components/game_part.dart';
import '../components/outer_space_game_part/controllable_components/astronaut_outdoor_character_part.dart';
import '../components/outer_space_game_part/controllable_components/space_ship/space_ship.dart';
import '../components/outer_space_game_part/environment_components/debris_component.dart';
import '../components/outer_space_game_part/environment_components/rocky_moon.dart';
import '../components/outer_space_game_part/environment_components/space_station_exterior.dart';
import '../components/outer_space_game_part/ui_components/dialog_box/dialogue_box_large.dart';
import '../hud.dart';

part 'outer_space_game_part_input.dart';

class OuterSpaceGamePart extends GamePart {
  static const double starterPlanetRadius = 350.00;
  static const double starterPlanetMass = 10000; // KG ??
  static const double zoomOutMultiplier = 1;
  static const bool isDebugMode = true;
  bool isSoundEnabled = false;

  bool canGuyEnterShip = false;
  bool isGuyOutsideShip = true;
  bool canPlayerInitiateDialogue = false;

  late DialogueBoxLarge dialogueBoxComponent;

  final pauseOverlayIdentifier = 'PauseMenu';
  final dialogueOverlayIdentifier = 'DialogueScreen';

  late HUDComponent hudComponent;
  late AstronautOutdoorCharacterPart astronaut;
  late SpaceShip spaceShip;
  late RockyMoon rockyMoon;

  TextStyle mainTextFontStyle = const TextStyle(
    color: Color(0xFFD9BB26),
    fontSize: 12,
    fontFamily: 'Roboto',
  );

  late SpaceStationExterior spaceStationExterior;
  //
  @override
  Future<void> onLoad() async {
    debugMode = isDebugMode;
    await Flame.images.load('astronaut4.png');
    await Flame.images.load('Lunar_03-512x512.png');
    await Flame.images.load('spr_stars02.png');
    await Flame.images.load('spr_stars01.png');
    await Flame.images.load('space_station_exterior.png');
    await Flame.images.load('ui_elements/button_x.png');
    await Flame.images.load('debris/rock_1.png');
    await Flame.images.load('debris/rock_2.png');
    await Flame.images.load('debris/probe_1.png');

    dialogueBoxComponent = DialogueBoxLarge();

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

    rockyMoon = RockyMoon(
      radius: starterPlanetRadius,
      offset: const Offset(0, 0),
      positionVector: Vector2(500, 500),
    );

    world.add(parallaxBackground1);

    world.add(rockyMoon);

    populateVicinityWithDebris(
      500,
      500,
    );

    astronaut =
        AstronautOutdoorCharacterPart(initialPosition: Vector2(500, 125));
    world.add(astronaut);

    // Space ship on the other side of the moon
    spaceShip = SpaceShip(initialAngle: pi / 2);
    world.add(spaceShip);

    spaceStationExterior = SpaceStationExterior();

    world.add(spaceStationExterior);

    hudComponent = HUDComponent();
    camera.viewport.add(hudComponent);

    camera.viewfinder.visibleGameSize = Vector2(1000, 1000) * zoomOutMultiplier;
    camera.follow(
      astronaut,
    );
    camera.viewfinder.anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isGuyOutsideShip) {
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

  Future<void> exitDialogue() async {
    camera.viewport.remove(dialogueBoxComponent);
    if (isSoundEnabled) await FlameAudio.play('beep.mp3');
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
    final isArrowUp = keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isArrowDown = keysPressed.contains(LogicalKeyboardKey.arrowDown);
    final isKeySpace = keysPressed.contains(LogicalKeyboardKey.space);

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
      if (canPlayerInitiateDialogue) {
        camera.viewport.add(dialogueBoxComponent);
        return KeyEventResult.handled;
      }
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

    // Thrusting the space ship

    if (isArrowUp && isKeyDown && spaceShip.isUnderUserControlledThrust) {
      spaceShip.thrustingUp = true;
      return KeyEventResult.handled;
    } else if (isArrowDown &&
        isKeyDown &&
        spaceShip.isUnderUserControlledThrust) {
      spaceShip.thrustingDown = true;
      return KeyEventResult.handled;
    } else if (isArrowRight &&
        isKeyDown &&
        spaceShip.isUnderUserControlledThrust) {
      spaceShip.thrustingRight = true;
      return KeyEventResult.handled;
    } else if (isArrowLeft &&
        isKeyDown &&
        spaceShip.isUnderUserControlledThrust) {
      spaceShip.thrustingLeft = true;
      return KeyEventResult.handled;
    } else if (isKeySpace &&
        isKeyDown &&
        spaceShip.isUnderUserControlledThrust) {
      spaceShip.thrustingUp = false;
      spaceShip.thrustingDown = false;
      spaceShip.thrustingLeft = false;
      spaceShip.thrustingRight = false;
      spaceShip.cutThrust();

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

  void beginDebrisGathering() {
    // spaceShip.inOrbit = false;
    // rockyMoon.stopSpinning();
    // spaceShip.driftOut();
  }

  void alertUserToRadioForeman() {
    hudComponent.updateMessage("Press C to radio the foreman");
    canPlayerInitiateDialogue = true;
  }

  void populateVicinityWithDebris(double maximumXDist, double maximumYDist) {
    final debris1 = DebrisComponent(
      srcPath: 'debris/rock_1.png',
      positionVar: Vector2(800, -240),
      debrisSize: Vector2(113, 113),
      startingAngle: 0.0,
      angleVelocity: getRandomAngleVelocity(),
    );

    final debris2 = DebrisComponent(
      srcPath: 'debris/rock_2.png',
      positionVar: getRandomPositionWithinBounds(maximumXDist, maximumYDist),
      debrisSize: Vector2(70, 70),
      startingAngle: 0.0,
      angleVelocity: getRandomAngleVelocity(),
    );

    final debris4 = DebrisComponent(
      srcPath: 'debris/rock_1.png',
      positionVar: Vector2(1100, 500),
      debrisSize: Vector2(113, 113),
      startingAngle: 0.0,
      angleVelocity: getRandomAngleVelocity(),
    );

    final debris5 = DebrisComponent(
      srcPath: 'debris/rock_2.png',
      positionVar: getRandomPositionWithinBounds(maximumXDist, maximumYDist),
      debrisSize: Vector2(70, 70),
      startingAngle: 0.0,
      angleVelocity: getRandomAngleVelocity(),
    );

    final debris3 = DebrisComponent(
      srcPath: 'debris/probe_1.png',
      positionVar: Vector2(160, -200),
      debrisSize: Vector2(194, 176),
      startingAngle: 0.0,
      angleVelocity: getRandomAngleVelocity(),
    );
    world.add(debris1);
    world.add(debris2);
    world.add(debris3);
    world.add(debris4);
    world.add(debris5);
  }

  Vector2 getRandomPositionWithinBounds(
      double maximumXDist, double maximumYDist) {
    final random = Random();
    final xNeg = random.nextBool();
    final yNeg = random.nextBool();
    if (xNeg) {
      if (yNeg) {
        final x = random.nextDouble() * maximumXDist;
        final y = random.nextDouble() * maximumYDist;
        return Vector2(-x, -y);
      } else {
        final x = random.nextDouble() * maximumXDist;
        final y = random.nextDouble() * maximumYDist;
        return Vector2(-x, y);
      }
    } else {
      if (yNeg) {
        final x = random.nextDouble() * maximumXDist;
        final y = random.nextDouble() * maximumYDist;
        return Vector2(x, -y);
      } else {
        final x = random.nextDouble() * maximumXDist;
        final y = random.nextDouble() * maximumYDist;
        return Vector2(x, y);
      }
    }
  }

  double getRandomAngleVelocity() {
    double angleVelocity;
    final random = Random();
    final negative = random.nextBool();
    if (negative) {
      angleVelocity = (random.nextDouble() * 0.1 + 0.1) * -1;
    } else {
      angleVelocity = (random.nextDouble() * 0.1) + 0.1;
    }
    return angleVelocity;
  }
}
