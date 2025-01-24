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
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/debug_mode.dart';
import 'package:meditate_app/util/logger.dart';
import 'dart:math' as math;

import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';

import '../../models/user.dart';

class OtherTurtle extends SpriteAnimationComponent with HasGameRef, Tappable {
  static const speed = 0.25;
  static const squareSize = 200.0;
  final List<List<double>> elevation;

  OtherTurtle(Vector2 position, this.elevation) : super(position: position);

  int directionResetCounter = 0;
  double xOffset = Random().nextDouble() * 2 - 1;
  double yOffset = Random().nextDouble() * 2 - 1;

  @override
  void update(double dt) {
    super.update(dt);

    if (position.distanceTo(gameRef.camera.position) < 600) {
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

      if (position.y ~/ 100 + 100 > elevation.length) {
        return;
      }
      if (position.x ~/ 100 + 100 > elevation[0].length) {
        return;
      }
      if (elevation[position.y ~/ 100 + 100][position.x ~/ 100 + 100] > 0.1) {
        priority = 102;
      } else {
        priority = 9;
      }
    }
  }

  late int turtleColor;
  late int turtleType;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 9;
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

    if (turtleType == 21) {
      Sprite underlay = await gameRef.loadSprite(
        'turtles/21_underlay.png',
      );

      add(SpriteComponent(sprite: underlay, size: Vector2(200, 200)));
    }

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

    if (turtleType == 23) {
      Sprite overlay2 = await gameRef.loadSprite(
        'turtles/23_overlay.png',
      );

      add(SpriteComponent(sprite: overlay2, size: Vector2(200, 200)));
    }

    if (turtleColor == 18) {
      if (turtleType == 10) {
        Sprite overlayRainbow = await gameRef.loadSprite(
          'turtles/overlay_rainbow_crystal.png',
        );

        add(SpriteComponent(
          sprite: overlayRainbow,
          size: Vector2(200, 200),
        ));
      } else {
        Sprite overlayRainbow = await gameRef.loadSprite(
          'turtles/overlay_rainbow_default.png',
        );

        add(SpriteComponent(
          sprite: overlayRainbow,
          size: Vector2(200, 200),
        ));
      }
    }

    anchor = Anchor.center;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    HapticFeedback.mediumImpact();
    GameController game = Get.find();
    if (game.localContext != null) {
      _showTurtleDialog(turtleColor, turtleType);
    }
    info.handled = true;
    return true;
  }
}

//TODO: validate changes
Future<void> _showTurtleDialog(int turtleColor, int turtleType) async {
  UserController userController = Get.find();
  GameController game = Get.find();
  EggController egg = Get.find();
  if (TURTLES[turtleType].foundIn != null) {
    return showDialog<void>(
        context: game.localContext!,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            // add a border
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('You need to meditate with the ' +
                      TURTLES[turtleType].foundIn!.name +
                      ' ambience to collect this turtle!'),
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
  } else if (TURTLES[turtleType].tier.index == Tier.LITBACK.index) {
    return showDialog<void>(
        context: game.localContext!,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                      'You need to add at least one friend on Shellevate to breed this turtle!'),
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
  } else if (TURTLES[turtleType].level >
      calculateLevel(userController.user.value.levelPoints)) {
    return showDialog<void>(
        context: game.localContext!,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'You need to be Level ${TURTLES[turtleType].level.toString()} to breed with this turtle!'),
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
  } else {
    return showDialog<void>(
      context: game.localContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.white, width: 2),
          ),
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
                      PostHogService posthog = Get.find();
                      posthog.logEvent("BRED_TURTLE", {});

                      Get.to(const NewEggPage());
                    },
                  ),
          ],
        );
      },
    );
  }
}
