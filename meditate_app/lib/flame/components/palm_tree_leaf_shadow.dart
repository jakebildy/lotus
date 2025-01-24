import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:meditate_app/util/util.dart';

class PalmTreeLeafShadow extends SpriteComponent with HasGameRef {
  static const speed = 0.25;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();
  final double treeSize;

  PalmTreeLeafShadow(Vector2 position, double angle, this.treeSize)
      : super(position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 106;
    sprite = await gameRef.loadSprite('game/palm_tree.webp');
    size.setValues(treeSize, treeSize);
    angle = angle;
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    // Render the actual sprite
    // super.render(canvas);
    // Draw the shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..blendMode = BlendMode.xor;

    canvas.save();

    // Apply transformation for shadow

    final shadowOffset = unrotateOffset(
        const Offset(0, 0), angle); // Light source direction offset

    canvas.translate(shadowOffset.dx, shadowOffset.dy);

    // Render the shadow as a distorted version of the sprite
    sprite?.render(
      canvas,
      position: Vector2.zero(),
      size: size,
      overridePaint: shadowPaint,
    );

    canvas.restore();
  }

  // @override
  // bool onTapUp(TapUpInfo info) {
  //   removeFromParent();
  //   info.handled = true;
  //   return true;
  // }
}
