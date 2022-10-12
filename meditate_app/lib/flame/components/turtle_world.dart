import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:meditate_app/flame/turtlegame.dart';

class TurtleWorld extends ParallaxComponent<TurtleGame> {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('game/sand.jpeg'),
        ParallaxImageData('game/water.png'),
        ParallaxImageData('game/water.png'),
        ParallaxImageData('game/water.png'),
      ],
      baseVelocity: Vector2(0, 0),
      velocityMultiplierDelta: Vector2(1.4, 1.4),
      repeat: ImageRepeat.repeat,
    );
  }
}
