import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/egg_controller.dart';
import 'package:meditate_app/controllers/game_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/new_egg_page.dart';
import 'package:meditate_app/util/debug_mode.dart';
import 'package:meditate_app/util/logger.dart';
import 'dart:math' as math;

import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';

import '../../models/user.dart';

class OtherTurtle extends SpriteAnimationComponent with HasGameRef, Tappable {
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

// only turtles without a foundIn property can be found in the wild
    turtleType = Random().nextInt(TURTLES.length);
    turtleColor = Random().nextInt(TURTLE_COLORS.length);
    Sprite overlay = await gameRef.loadSprite(
      'turtles/$turtleType.png',
    );
    Paint newPaint = Paint()
      ..colorFilter = ColorFilter.mode(
          TURTLE_COLORS[turtleColor].withOpacity(0.4), BlendMode.srcATop);

    add(SpriteComponent(
        sprite: overlay, size: Vector2(200, 200), paint: newPaint));

    //crystal turtle overlay
    if (turtleType == 10) {
      Sprite overlay2 = await gameRef.loadSprite(
        'turtles/10_overlay.png',
      );

      add(SpriteComponent(sprite: overlay2, size: Vector2(200, 200)));
    }
    anchor = Anchor.center;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    HapticFeedback.mediumImpact();
    GameController game = Get.find();
    if (game.localContext != null) {
      _showMyDialog(turtleColor, turtleType);
    }
    info.handled = true;
    return true;
  }
}

Future<void> _showMyDialog(int turtleColor, int turtleType) async {
  UserController userController = Get.find();
  GameController game = Get.find();
  EggController egg = Get.find();

  if (TURTLES[turtleType].tier.index > userController.streakTier().index) {
    return showDialog<void>(
        context: game.localContext!,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            //  title: const Text('AlertDialog Title'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'You need to be a ${tierReadable(TURTLES[turtleType].tier)} to breed with this turtle!'),
                  const Text('\nIncrease your level by meditating more.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Okay',
                  style: TextStyle(color: Colors.tealAccent),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  } else if (TURTLES[turtleType].foundIn != null) {
    return showDialog<void>(
        context: game.localContext!,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            //  title: const Text('AlertDialog Title'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('You need to meditate with the ' +
                      TURTLES[turtleType].foundIn!.name +
                      ' ambience to find this turtle!'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Okay',
                  style: TextStyle(color: Colors.tealAccent),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  } else {
    return showDialog<void>(
      context: game.localContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //  title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                (!DEBUG_MODE && userController.user.value.gems < 50)
                    ? const Text(
                        "You need at least 50 sand dollars to breed this turtle!")
                    : Text(
                        'Breed your ${TURTLE_COLORS_NAME[game.turtleColor.value]} ${TURTLES[game.selectedTurtle.value].name} with this ${TURTLE_COLORS_NAME[turtleColor]} ${TURTLES[turtleType].name} for 50 sand dollars?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            (!DEBUG_MODE && userController.user.value.gems < 50)
                ? Container()
                : TextButton(
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.tealAccent),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (!DEBUG_MODE) {
                        userController.updateProperty(UserProperty.gems,
                            userController.user.value.gems - 50);
                      }

                      bool babyType = Random().nextBool();
                      int futureColor =
                          !babyType ? game.turtleColor.value : turtleColor;
                      int futureType =
                          babyType ? game.selectedTurtle.value : turtleType;
                      logInfo("NEW TURTLE 🐢: " +
                          TURTLE_COLORS_NAME[futureColor] +
                          " " +
                          TURTLES[futureType].name);
                      egg.addEgg(futureColor, futureType);

                      Get.to(const NewEggPage());
                    },
                  ),
          ],
        );
      },
    );
  }
}
