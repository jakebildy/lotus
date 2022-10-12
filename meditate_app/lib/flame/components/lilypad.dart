import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Lilypad extends SpriteComponent with HasGameRef, Tappable {
  static const speed = 0.25;
  static const squareSize = 70.0;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  Lilypad(Vector2 position) : super(position: position);

  @override
  void update(double dt) {
    super.update(dt);
    // angle += speed * dt;
    // angle %= 2 * math.pi;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('game/lilypad.png');
    size.setValues(squareSize, squareSize);
    anchor = Anchor.center;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    removeFromParent();
    HapticFeedback.mediumImpact();
    info.handled = true;
    return true;
  }
}
