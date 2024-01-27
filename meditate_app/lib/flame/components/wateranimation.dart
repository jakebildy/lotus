import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class WaterAnimation extends SpriteAnimationComponent with HasGameRef {
  final double lilypadSize;
  late SpriteAnimation _animation;

  WaterAnimation(Vector2 position, this.lilypadSize)
      : super(
            position: position,
            size: Vector2.all(lilypadSize),
            anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final spriteSheet = await gameRef.images
        .load('game/water_spritesheet2.png'); // Your spritesheet file
    //        // 512px by 512px
    final spriteSize = Vector2(128, 128); // The size of a single sprite

    // Create a sprite sheet animation
    final spriteSheetAnimation = SpriteSheet(
      image: spriteSheet,
      srcSize: spriteSize,
    );

    _animation = spriteSheetAnimation.createAnimation(
      row: 0,
      stepTime: 0.1, // Adjust the frame switch time

      loop: true,
    );

    animation = _animation;
    opacity = 0.4;

    // You can add hitboxes or other components here if needed
  }

  // Override this method if you need to handle tap events
  // @override
  // bool onTapUp(TapUpInfo info) {
  //   return true;
  // }

  // Add any additional logic you need in the update method
  // @override
  // void update(double dt) {
  //   super.update(dt);
  //   // Custom update logic
  // }
}
