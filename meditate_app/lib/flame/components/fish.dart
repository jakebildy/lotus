import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:meditate_app/util/turtles.dart';

class Fish extends SpriteAnimationComponent with HasGameRef, Tappable {
  static const speed = 0.25;
  static const squareSize = 70.0;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  Fish(Vector2 position) : super(position: position);

  int directionResetCounter = 0;
  double xOffset = Random().nextDouble() * 2 - 1;
  double yOffset = Random().nextDouble() * 2 - 1;

  @override
  void update(double dt) {
    super.update(dt);
    directionResetCounter += 1;
    angle = math.atan2((position.x + xOffset * 100) - position.x,
        -1 * ((position.y + yOffset * 100) - position.y));
    if (directionResetCounter >= 200 + Random().nextInt(50)) {
      xOffset = Random().nextDouble() * 2 - 1;
      yOffset = Random().nextDouble() * 2 - 1;
      directionResetCounter = 0;
      angle = math.atan2((position.x + xOffset * 100) - position.x,
          -1 * ((position.y + yOffset * 100) - position.y));
    }

    add(
      MoveByEffect(
          Vector2((position.x + xOffset / 2) - position.x,
              (position.y + yOffset / 2) - position.y),
          EffectController(duration: 0.1)),
    );
    // angle += speed * dt;
    // angle %= 2 * math.pi;
  }

  late int fishColor;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    fishColor = Random().nextInt(2);

    final sprites = fishColor == 1
        ? [Sprite.load("game/fish.png"), Sprite.load("game/fish2.png")]
        : [Sprite.load("game/fish_2.png"), Sprite.load("game/fish_2_2.png")];
    animation =
        SpriteAnimation.spriteList(await Future.wait(sprites), stepTime: 0.4);

    //sprite = await gameRef.loadSprite('game/fish.png');

    size.setValues(squareSize, squareSize);
    anchor = Anchor.center;
  }
}
