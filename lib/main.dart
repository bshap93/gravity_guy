import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gravity_guy/game_parts/proxima_space_station_game_part.dart';

void main() {
  // final game = OuterSpaceGamePart();
  final game = ProximaSpaceStationGamePart();
  runApp(GameWidget(game: game));
}
