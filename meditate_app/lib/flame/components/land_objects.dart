import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:meditate_app/util/util.dart';

class LandItems extends SpriteComponent with HasGameRef {
  static const speed = 0.25;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  final double seafloorObjectSize;

  LandItems(Vector2 position, this.seafloorObjectSize)
      : super(position: position);

  int variant = 0;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 101;
    variant = Random().nextInt(10);

    if (variant == 0) {
      sprite = await gameRef.loadSprite(
        'game/shell_1.png',
      );
      size.setValues(seafloorObjectSize, seafloorObjectSize);
      size.setValues(seafloorObjectSize / 1.5, seafloorObjectSize / 1.5);
      angle = Random().nextInt(360).toDouble();
    } else if (variant == 1) {
      sprite = await gameRef.loadSprite('game/shell_1.png');
      size.setValues(seafloorObjectSize / 2, seafloorObjectSize / 2);
      angle = Random().nextInt(360).toDouble();
    } else if (variant == 2) {
      sprite = await gameRef.loadSprite('game/starfish_1.png');
      size.setValues(seafloorObjectSize, seafloorObjectSize);
      angle = Random().nextInt(360).toDouble();
    } else {
      sprite = await gameRef.loadSprite('game/tiny_plant.png');

      // size.setValues(seafloorObjectSize / 1.5, seafloorObjectSize / 1.5);
    }

    // random rotation

    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    // Render the actual sprite
    super.render(canvas);

    if (variant > 2) {
      // Draw the shadow
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..blendMode = BlendMode.xor;

      canvas.save();

      // Apply transformation for shadow

      final shadowOffset = unrotateOffset(
          const Offset(10, 75), angle); // Light source direction offset

      canvas.translate(shadowOffset.dx, shadowOffset.dy);
      //  flip vertical
      canvas.scale(1, -0.5);

      // Render the shadow as a distorted version of the sprite
      sprite?.render(
        canvas,
        position: Vector2.zero(),
        size: size,
        overridePaint: shadowPaint,
      );

      canvas.restore();
    }
  }
}
