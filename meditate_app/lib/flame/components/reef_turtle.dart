import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/pages/turtle_details_page.dart';

import '../../util/turtles.dart';

class ReefTurtle extends SpriteAnimationComponent with HasGameRef, Tappable {
  static const speed = 0.25;
  static const squareSize = 100.0;

  ReefTurtle(Vector2 position, int type, int color)
      : super(position: position) {
    turtleType = type;
    turtleColor = color;
  }

  int directionResetCounter = 0;
  bool isStationaryPeriod = true; // Initially stationary
  double xOffset = Random().nextDouble() * 2 - 1;
  double yOffset = Random().nextDouble() * 2 - 1;

  @override
  void update(double dt) {
    super.update(dt);

    directionResetCounter += 1;

    // Check if the direction reset counter has reached its reset interval
    int resetInterval = 200 + Random().nextInt(50);
    if (directionResetCounter >= resetInterval) {
      // Randomly determine if this period will be stationary (75%) or active (25%)
      isStationaryPeriod = Random().nextDouble() < 0.75;

      // Reset direction and counters for the next period
      if (!isStationaryPeriod) {
        xOffset = Random().nextDouble() * 2 - 1;
        yOffset = Random().nextDouble() * 2 - 1;
      }
      directionResetCounter = 0;
    }

    // If this is a stationary period, do nothing
    if (isStationaryPeriod) {
      return;
    }

    // Normal movement behavior during active periods
    angle = atan2((position.x + xOffset * 100) - position.x,
        -1 * ((position.y + yOffset * 100) - position.y));

    add(
      MoveByEffect(
          Vector2((position.x + xOffset / 5) - position.x,
              (position.y + yOffset / 5) - position.y),
          EffectController(duration: 0.1)),
    );
  }

  late int turtleColor;
  late int turtleType;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final sprites = [
      Sprite.load("turtles/swim/swim1.png"),
      Sprite.load("turtles/swim/swim2.png")
    ];
    animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.4 + Random().nextDouble() / 10,
    );
    size.setValues(squareSize, squareSize);

    Sprite overlay = await gameRef.loadSprite(
      'turtles/$turtleType.png',
    );

    if (turtleType == 21) {
      Sprite underlay = await gameRef.loadSprite(
        'turtles/21_underlay.png',
      );

      add(SpriteComponent(sprite: underlay, size: Vector2(100, 100)));
    }

    Paint newPaint = Paint()
      ..colorFilter = ColorFilter.mode(
          TURTLE_COLORS[turtleColor].withOpacity(0.4), BlendMode.srcATop);

    add(SpriteComponent(
        sprite: overlay, size: Vector2(100, 100), paint: newPaint));

    // Crystal turtle overlay
    if (turtleType == 10) {
      Sprite overlay2 = await gameRef.loadSprite(
        'turtles/10_overlay.png',
      );

      add(SpriteComponent(sprite: overlay2, size: Vector2(100, 100)));
    }

    if (turtleType == 23) {
      Sprite overlay2 = await gameRef.loadSprite(
        'turtles/23_overlay.png',
      );

      add(SpriteComponent(sprite: overlay2, size: Vector2(100, 100)));
    }

    if (turtleColor == 18) {
      if (turtleType == 10) {
        Sprite overlayRainbow = await gameRef.loadSprite(
          'turtles/overlay_rainbow_crystal.png',
        );

        add(SpriteComponent(
          sprite: overlayRainbow,
          size: Vector2(100, 100),
        ));
      } else {
        Sprite overlayRainbow = await gameRef.loadSprite(
          'turtles/overlay_rainbow_default.png',
        );

        add(SpriteComponent(
          sprite: overlayRainbow,
          size: Vector2(100, 100),
        ));
      }
    }

    anchor = Anchor.center;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    HapticFeedback.mediumImpact();

    Get.to(TurtleDetailsPage(id: turtleType, color: turtleColor),
        transition: Transition.downToUp);
    return true;
  }
}
