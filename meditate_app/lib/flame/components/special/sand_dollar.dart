import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/models/user.dart';

import '../../../controllers/game_controller.dart';

class SandDollar extends SpriteComponent with HasGameRef, Tappable {
  static const speed = 0.25;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();
  final double rockSize;

  SandDollar(Vector2 position, this.rockSize) : super(position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('game/sand_dollar.png');
    size.setValues(rockSize, rockSize);
    angle = Random().nextDouble() * 2 * pi;
    anchor = Anchor.center;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    HapticFeedback.mediumImpact();
    GameController game = Get.find();
    if (game.localContext != null) {
      _showFoundSandDollarDialog();
    }
    info.handled = true;
    return true;
  }

  Future<void> _showFoundSandDollarDialog() async {
    GameController game = Get.find();

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
                  Text('You found a sand dollar!'),
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
                  UserController user = Get.find();
                  user.updateProperty(
                      UserProperty.gems, user.user.value.gems + 1);
                  Navigator.of(context).pop();
                  // remove the sand dollar from the game
                  gameRef.remove(this);
                },
              ),
            ],
          );
        });
  }
}
