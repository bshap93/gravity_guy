import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game_parts/outer_space_game_part.dart';

void main() {
  final game = OuterSpaceGamePart();
  // final game = ProximaSpaceStationGamePart();
  runApp(GameWidget(game: game));
}
