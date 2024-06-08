import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class GamePart extends FlameGame
    with KeyboardEvents, HasCollisionDetection, HasGameRef<GamePart> {}
