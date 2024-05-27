import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import 'game_parts/outer_space_game_part.dart';

class GameOverview extends StatefulWidget {
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
  WidgetsFlutterBinding.ensureInitialized();
  FlameAudio.bgm.initialize();
  final game = OuterSpaceGamePart();
  // final game = ProximaSpaceStationGamePart();
  FlameAudio.bgm.play('bg_music_1.mp3');
  runApp(GameWidget(
    game: game,
    initialActiveOverlays: ['DateAndTime'],
    overlayBuilderMap: {
      'DateAndTime': (BuildContext context, OuterSpaceGamePart game) {
        return Container(
          color: Colors.black.withOpacity(0),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                child: Text(
                  "LY 2233, 09/26",
                  style: game.mainTextFontStyle.copyWith(
                    fontSize: 12,
                    color: const Color(0xFFD9BB26),
                  ),
                ),
              )
            ],
          ),
        );
      },
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
