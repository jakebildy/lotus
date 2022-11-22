import 'dart:math';

import 'package:cool_alert/cool_alert.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/pages/new_egg_page.dart';
import 'dart:math' as math;

import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';

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

    turtleType = Random().nextInt(TURTLES.length);
    turtleColor = Random().nextInt(TURTLE_COLORS.length);
    Sprite overlay = await gameRef.loadSprite(
      'turtles/${turtleType}.png',
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
    SaveController saveController = Get.find();
    if (saveController.localContext != null) {
      _showMyDialog(turtleColor, turtleType);
    }
    info.handled = true;
    return true;
  }
}

Future<void> _showMyDialog(int turtleColor, int turtleType) async {
  SaveController saveController = Get.find();

  if (TURTLES[turtleType].tier.index > saveController.streakTier().index) {
    return showDialog<void>(
        context: saveController.localContext!,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            //  title: const Text('AlertDialog Title'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'You need to be a ${tierReadable(TURTLES[turtleType].tier)} to breed with this turtle!'),
                  Text('\nIncrease your level by meditating more.'),
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
      context: saveController.localContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //  title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                saveController.gems.value < 50
                    ? Text("You need at least 50 gems to breed this turtle!")
                    : Text(
                        'Breed your ${TURTLE_COLORS_NAME[saveController.turtleColor.value]} ${TURTLES[saveController.selectedTurtle.value].name} with this ${TURTLE_COLORS_NAME[turtleColor]} ${TURTLES[turtleType].name} for 50 gems?'),
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
            saveController.gems.value < 50
                ? Container()
                : TextButton(
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.tealAccent),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      saveController.updateGems(saveController.gems.value - 50);

                      if (saveController.getValue("eggs") == "") {
                        saveController.updateEggs(1);
                      } else {
                        saveController.updateEggs(
                            int.parse(saveController.getValue("eggs")) + 1);
                      }

                      if (saveController.getValue("total_eggs") == "") {
                        saveController.updateTotalEggs(1);
                      } else {
                        saveController.updateTotalEggs(
                            int.parse(saveController.getValue("total_eggs")) +
                                1);
                      }

                      bool babyType = Random().nextBool();
                      int futureColor = !babyType
                          ? saveController.turtleColor.value
                          : turtleColor;
                      int futureType = babyType
                          ? saveController.selectedTurtle.value
                          : turtleType;

                      saveController.addFutureTurtle(futureColor, futureType);

                      Get.to(NewEggPage());
                    },
                  ),
          ],
        );
      },
    );
  }
}
