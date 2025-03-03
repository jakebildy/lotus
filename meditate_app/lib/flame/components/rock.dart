import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Rock extends SpriteComponent with HasGameRef {
  static const speed = 0.25;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();
  final double rockSize;

  Rock(Vector2 position, this.rockSize) : super(position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('game/rock.png');
    size.setValues(rockSize, rockSize);
    angle = Random().nextDouble() * 2 * pi;
    anchor = Anchor.center;
  }
}
