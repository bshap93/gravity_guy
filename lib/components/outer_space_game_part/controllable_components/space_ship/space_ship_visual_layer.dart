import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:gravity_guy/components/outer_space_game_part/controllable_components/space_ship/shield.dart';

import '../../../../game_parts/outer_space_game_part.dart';

class SpaceShipVisualLayer extends SpriteAnimationComponent
    with HasGameRef<OuterSpaceGamePart> {
  SpaceShipVisualLayer({required this.parentSize});

  Vector2 parentSize;

  late Shield shield;

  Vector2 textureSize = Vector2(112, 48);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    priority = 10;
    size = parentSize;
    position = Vector2.zero();

    animation = await game.loadSpriteAnimation(
        'spaceship_02.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: textureSize,
        ));

    playing = false;
    shield = Shield(
        position: Vector2(width / 2, height / 2),
        ellipseHeight: 250,
        ellipseWidth: 250);
    add(shield);
  }

  void bobInPlace() {
    if (gameRef.isBobbingEnabled) {
      final ec = RepeatedEffectController(SineEffectController(period: 2), 5);
      final effect = MoveByEffect(Vector2(0, 5), ec);
      add(effect);
    }
  }

  void sprayParticlesBack(double angle) {
    final rnd = Random();

    add(
      ParticleSystemComponent(
        angle: angle,
        anchor: Anchor.center,
        particle: AcceleratedParticle(
          // Will fire off in the center of game canvas
          position: Vector2(2 * width / 5, 4 * height / 5),

          // With random initial speed of Vector2(-100..100, 0..-100)
          speed:
              -Vector2(rnd.nextDouble() * 200 - 100, -rnd.nextDouble() * 100),
          // Accelerating downwards, simulating "gravity"
          // speed: Vector2(0, 100),
          child: CircleParticle(
            radius: 2.0,
            paint: Paint()..color = Colors.white,
          ),
        ),
      ),
    );
    add(
      ParticleSystemComponent(
        anchor: Anchor.center,
        angle: angle,
        particle: AcceleratedParticle(
          // Will fire off in the center of game canvas
          position: Vector2(3 * width / 5, 4 * height / 5),
          // With random initia l speed of Vector2(-100..100, 0..-100)
          speed:
              -Vector2(rnd.nextDouble() * 200 - 100, -rnd.nextDouble() * 100),
          // Accelerating downwards, simulating "gravity"
          // speed: Vector2(0, 100),
          child: CircleParticle(
            radius: 2.0,
            paint: Paint()..color = Colors.white,
          ),
        ),
      ),
    );
  }
}
