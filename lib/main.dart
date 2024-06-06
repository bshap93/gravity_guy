import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game_parts/outer_space_game_part.dart';

class GameOverview extends StatefulWidget {
  const GameOverview({super.key});

  @override
  _GameOverviewState createState() => _GameOverviewState();
}

class _GameOverviewState extends State<GameOverview> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void main() {
  // FlameAudio.bgm.initialize();
  final game = OuterSpaceGamePart();

  runApp(GameWidget(
    game: game,
    overlayBuilderMap: {
      'PauseMenu': (BuildContext context, OuterSpaceGamePart game) {
        return Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: GestureDetector(
              onTap: () {
                game.unPauseGame('PauseMenu');
              },
              child: Text(
                'Resume',
                style: game.mainTextFontStyle.copyWith(
                  fontSize: 32,
                  color: const Color(0xFFD9BB26),
                ),
              ),
            ),
          ),
        );
      },
    },
  ));
}
