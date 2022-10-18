import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Lilypad extends SpriteComponent with HasGameRef, Tappable {
  static const speed = 0.25;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  final double lilypadSize;

  Lilypad(Vector2 position, this.lilypadSize) : super(position: position);

  @override
  void update(double dt) {
    super.update(dt);
    // angle += speed * dt;
    // angle %= 2 * math.pi;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    int variant = Random().nextInt(5);
    if (variant == 0) {
      sprite = await gameRef.loadSprite('game/lilypad.png');
    } else if (variant == 1) {
      sprite = await gameRef.loadSprite('game/lilypad2.png');
    } else if (variant == 2) {
      sprite = await gameRef.loadSprite('game/lilypad3.png');
    } else if (variant == 3) {
      sprite = await gameRef.loadSprite('game/lilypad4.png');
    } else {
      sprite = await gameRef.loadSprite('game/lilypad5.png');
    }
    size.setValues(lilypadSize, lilypadSize);
    anchor = Anchor.center;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    //  size.setValues(0, 0);
    HapticFeedback.mediumImpact();
    info.handled = true;

    popBack();
    return true;
  }

  Future<void> popBack() async {
    //  await Future.delayed(Duration(seconds: Random().nextInt(2) + 1));
    //size.setValues(lilypadSize, lilypadSize);
  }
}
