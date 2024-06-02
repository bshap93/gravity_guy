import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class GamePart extends FlameGame
    with
        KeyboardEvents,
        HasCollisionDetection,
        HasGameRef<GamePart>,
        TapDetector {}
