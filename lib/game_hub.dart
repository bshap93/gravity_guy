import 'components/inherited_components/game_part.dart';

class GameHub {
  final List<GamePart> gameParts = [];

  void addGamePart(GamePart gamePart) {
    gameParts.add(gamePart);
  }

  void removeGamePart(GamePart gamePart) {
    gameParts.remove(gamePart);
  }
}
