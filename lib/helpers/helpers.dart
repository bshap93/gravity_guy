import 'dart:math';

import 'package:flame/components.dart';

double Vector2ToRadian(Vector2 direction) {
  double angle = 2 * pi - atan2(direction.x, direction.y);
  return angle;
}

extension Vector2Extension on Vector2 {
  Vector2 perpendicular() {
    return Vector2(-y, x);
  }
}
