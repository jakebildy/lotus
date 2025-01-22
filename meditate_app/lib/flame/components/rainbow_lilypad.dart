import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import '../../util/turtles.dart';

class RainbowLilypad extends SpriteComponent with HasGameRef {
  static const speed = 0.25;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  final double lilypadSize;

  RainbowLilypad(Vector2 position, this.lilypadSize)
      : super(position: position);

  late int lilypadColor;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 5;
    sprite = await gameRef.loadSprite('game/lilypad3.png');
    size.setValues(lilypadSize, lilypadSize * 14 / 16);
    anchor = Anchor.center;

    lilypadColor = Random().nextInt(TURTLE_COLORS.length);

    //mostly pink and white
    if (Random().nextInt(10) < 3) {
      lilypadColor = 14;
    } else if (Random().nextInt(10) < 3) {
      lilypadColor = 17;
    } else if (Random().nextInt(10) < 2) {
      lilypadColor = 13;
    }

    // if lilypadColor is black, brown or grey, make it 14
    if (lilypadColor == 0 ||
        lilypadColor == 15 ||
        lilypadColor == 16 ||
        lilypadColor == 18) {
      lilypadColor = 14;
    }

    Sprite overlay = await gameRef.loadSprite(
      'game/lilypad_flower.png',
    );

    Paint newPaint = Paint()
      ..colorFilter = ColorFilter.mode(
          TURTLE_COLORS[lilypadColor].withOpacity(0.5), BlendMode.srcATop);

    add(SpriteComponent(
        sprite: overlay,
        size: Vector2(lilypadSize, lilypadSize * 14 / 16),
        paint: newPaint));
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
