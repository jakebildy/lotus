import 'dart:math';

import 'package:cool_alert/cool_alert.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'package:meditate_app/util/turtles.dart';

class OtherTurtle extends SpriteComponent with HasGameRef, Tappable {
  static const speed = 0.25;
  static const squareSize = 200.0;

  OtherTurtle(Vector2 position) : super(position: position);

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

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = await gameRef.loadSprite('turtles/template.png');
    size.setValues(squareSize, squareSize);

    int turtleType = Random().nextInt(TURTLES.length);
    int turtleColor = Random().nextInt(TURTLE_COLORS.length);
    Sprite overlay = await gameRef.loadSprite(
      'turtles/${turtleType}.png',
    );
    Paint newPaint = Paint()
      ..colorFilter = ColorFilter.mode(
          TURTLE_COLORS[turtleColor].withOpacity(0.4), BlendMode.srcATop);

    add(SpriteComponent(
        sprite: overlay, size: Vector2(200, 200), paint: newPaint));

    anchor = Anchor.center;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    HapticFeedback.mediumImpact();
    // CoolAlert.show(
    //   context: context,
    //   type: CoolAlertType.warning,
    //   text: 'Breed your turtle with this one?',
    // );
    info.handled = true;
    return true;
  }
}
