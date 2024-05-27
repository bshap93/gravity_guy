import 'package:flame/layers.dart';
import 'package:gravity_guy/game_parts/outer_space_game_part.dart';

class HUDLayer extends DynamicLayer {

  OuterSpaceGamePart game;

  HUDLayer(this.game);
  @override
  void drawLayer() {
    game.dialogueBoxComponent.render(canvas);
  }
}