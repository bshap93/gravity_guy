import 'package:flutter/material.dart';

import 'components/inherited_components/game_part.dart';

class GameHub extends StatelessWidget {
  final List<GamePart> gameParts = [];

  void addGamePart(GamePart gamePart) {
    gameParts.add(gamePart);
  }

  void removeGamePart(GamePart gamePart) {
    gameParts.remove(gamePart);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
