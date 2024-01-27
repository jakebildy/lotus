import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class SeaFloorObject extends SpriteComponent with HasGameRef {
  static const speed = 0.25;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  final double seafloorObjectSize;

  SeaFloorObject(Vector2 position, this.seafloorObjectSize)
      : super(position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    int variant = Random().nextInt(3);

    if (variant == 0) {
      sprite = await gameRef.loadSprite(
        'game/rock.png',
      );
      size.setValues(seafloorObjectSize, seafloorObjectSize);
    } else if (variant == 1) {
      sprite = await gameRef.loadSprite('game/shell_1.png');
      size.setValues(seafloorObjectSize / 2, seafloorObjectSize / 2);
    } else {
      sprite = await gameRef.loadSprite('game/starfish_1.png');
      size.setValues(seafloorObjectSize, seafloorObjectSize);
    }

    // random rotation
    angle = Random().nextInt(360).toDouble();
    anchor = Anchor.center;
  }
}
