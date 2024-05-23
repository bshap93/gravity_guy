import 'dart:ui';

import 'package:flame/components.dart';
import 'package:google_fonts/google_fonts.dart';

class InteractionText extends TextComponent {
  InteractionText({
    required Vector2 positionVector,
    required String text,
  }) : super(
          text: text,
          anchor: Anchor.topRight,
          textRenderer: TextPaint(
              style: GoogleFonts.getFont('Nabla').copyWith(
                color: const Color(0xFFD9BB26),
                fontSize: 32,
              ),
              textDirection: TextDirection.ltr),
        );
}
