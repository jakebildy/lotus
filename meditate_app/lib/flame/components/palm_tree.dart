import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class PalmTree extends SpriteComponent with HasGameRef, Tappable {
  static const speed = 0.25;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();
  final double treeSize;

  PalmTree(Vector2 position, this.treeSize) : super(position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 103;
    sprite = await gameRef.loadSprite('game/palm_tree.webp');
    size.setValues(treeSize, treeSize);
    angle = Random().nextDouble() * 2 * pi;
    anchor = Anchor.center;
  }

  // @override
  // bool onTapUp(TapUpInfo info) {
  //   removeFromParent();
  //   info.handled = true;
  //   return true;
  // }
}
