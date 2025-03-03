import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/countdown_controller.dart';
import 'package:meditate_app/controllers/game_controller.dart';
import 'package:meditate_app/pages/countdown/countdown_page.dart';

import '../../util/util.dart';

class TreasureChest extends SpriteComponent with HasGameRef, TapCallbacks {
  final double xSize;

  TreasureChest(Vector2 position, this.xSize) : super(position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 101;
    sprite = await gameRef.loadSprite('game/x.png');
    size.setValues(xSize, xSize);
    anchor = Anchor.center;
  }

  @override
  void onTapUp(TapUpEvent event) {
    HapticFeedback.mediumImpact();
    GameController game = Get.find();
    if (game.localContext != null) {
      _showXDialog();
    }
    event.handled = true;
    return;
  }

  @override
  void render(Canvas canvas) {
    // Render the actual sprite
    super.render(canvas);

    // Draw the shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..blendMode = BlendMode.xor;

    canvas.save();

    // Apply transformation for shadow

    final shadowOffset = unrotateOffset(
        const Offset(4, 75), angle); // Light source direction offset

    canvas.translate(shadowOffset.dx, shadowOffset.dy);
    //  flip vertical
    canvas.scale(1, -0.5);

    // Render the shadow as a distorted version of the sprite
    sprite?.render(
      canvas,
      position: Vector2.zero(),
      size: size,
      overridePaint: shadowPaint,
    );

    canvas.restore();
  }

  Future<void> _showXDialog() async {
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
                children: const <Widget>[
                  Text('Meditate 3 minutes to open this treasure chest?'),
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
                  gameRef.remove(this);
                  HapticFeedback.heavyImpact();

                  CountdownController countdownController = Get.find();
                  countdownController.totalSeconds.value =
                      const Duration(minutes: 3).inSeconds;
                  countdownController.update();
                  Get.to(
                      const CountdownPage(
                          time: const Duration(minutes: 3),
                          ambience: "Water Sounds"),
                      transition: Transition.circularReveal,
                      duration: const Duration(seconds: 1));
                },
              ),
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
