import 'package:flutter/material.dart';
import 'package:gravity_guy/game_parts/outer_space_game_part.dart';

class DialogueScreenWidget extends StatelessWidget {
  const DialogueScreenWidget({
    super.key,
    required this.game,
  });

  final OuterSpaceGamePart game;

  @override
  Widget build(BuildContext context) {
    return Center(
      /// Ordered from bottom to top
      child: Stack(children: [
        Positioned(
            top: MediaQuery.of(context).size.height / 2 - 250,
            left: MediaQuery.of(context).size.width / 2 - 450,
            child: const SizedBox(
                height: 500,
                width: 900,
                child: Image(
                    image: AssetImage(
                        'assets/images/dialog_box_large-export.png')))),
        Positioned(
          right: MediaQuery.of(context).size.width / 2 - 310,
          top: MediaQuery.of(context).size.height / 2 - 215,
          child: GestureDetector(
              onTap: () {
                game.exitDialogue('DialogueScreen');
              },
              child: Image.asset('assets/images/ui_elements/button_x1.png')),
        ),
      ]),
    );
  }
}
