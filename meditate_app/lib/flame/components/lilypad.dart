import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Lilypad extends SpriteComponent with HasGameRef {
  static const speed = 0.25;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  final double lilypadSize;

  Lilypad(Vector2 position, this.lilypadSize) : super(position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 101;
    int variant = Random().nextInt(2);
    if (variant == 0) {
      sprite = await gameRef.loadSprite('game/lilypad.png');
    } else if (variant == 1) {
      sprite = await gameRef.loadSprite('game/lilypad2.png');
    }
    size.setValues(lilypadSize, lilypadSize * 7 / 8);
    anchor = Anchor.center;
  }

  // @override
  // bool onTapUp(TapUpInfo info) {
  //   //  size.setValues(0, 0);
  //   HapticFeedback.mediumImpact();
  //   info.handled = true;

  //   popBack();
  //   return true;
  // }

  Future<void> popBack() async {
    //  await Future.delayed(Duration(seconds: Random().nextInt(2) + 1));
    //size.setValues(lilypadSize, lilypadSize);
  }
}
