import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:meditate_app/util/util.dart';

class PalmTreeShadow extends SpriteComponent with HasGameRef {
  static const speed = 0.25;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();
  final double treeSize;

  PalmTreeShadow(Vector2 position, this.treeSize) : super(position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 103;
    sprite = await gameRef.loadSprite('game/palm_tree.webp');
    size.setValues(treeSize, treeSize);
    angle = Random().nextDouble() * 2 * pi;
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    // Render the actual sprite
    // super.render(canvas);
    // Draw the shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..blendMode = BlendMode.xor;

    canvas.save();

    // Apply transformation for shadow

    final shadowOffset =
        unrotateOffset(Offset(15, 20), angle); // Light source direction offset
    final shadowScale = 1.1; // Slightly scale the shadow for realism

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
