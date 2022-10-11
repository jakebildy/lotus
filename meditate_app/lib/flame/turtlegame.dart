import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/parallax.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/flame/components/bubble.dart';
import 'package:meditate_app/flame/components/lilypad.dart';
import 'package:meditate_app/flame/components/lotus.dart';
import 'package:meditate_app/flame/components/rock.dart';
import 'package:meditate_app/flame/components/turtle_world.dart';

class TurtleGame extends FlameGame with HasTappables {
  late Sprite background;
  TurtleWorld _turtleWorld = TurtleWorld();
  Player playerBase = Player(
      Vector2(
        400,
        400,
      ),
      true);
  Player player = Player(
      Vector2(
        400,
        400,
      ),
      false);
  CameraPoint cameraPoint = CameraPoint(Vector2(400, 400));

  @override
  Future<void> onLoad() async {
    add(_turtleWorld);
    add(player);
    add(playerBase);

    add(cameraPoint);

    for (int i = 0; i < 100; i++) {
      add(Rock(Vector2(math.Random().nextInt(2000).toDouble(),
          math.Random().nextInt(20000).toDouble())));
    }

    for (int i = 0; i < 100; i++) {
      add(Lilypad(Vector2(math.Random().nextInt(2000).toDouble(),
          math.Random().nextInt(20000).toDouble())));
    }

    camera.followComponent(cameraPoint);
  }

  @override
  void onDetach() {
    SaveController saveController = Get.find();
    saveController.stopGame();
    super.onDetach();
  }

  @override
  void onTapUp(int id, TapUpInfo info) {
    super.onTapUp(id, info);
    if (!info.handled) {
      final touchPoint = info.eventPosition.game;
      //add(Square(touchPoint));
      player.angle = math.atan2(touchPoint.x - player.position.x,
          -1 * (touchPoint.y - player.position.y));
      player.add(
        MoveByEffect(
            Vector2(touchPoint.x - player.position.x,
                touchPoint.y - player.position.y),
            EffectController(duration: 0.6)),
      );
      playerBase.angle = math.atan2(touchPoint.x - player.position.x,
          -1 * (touchPoint.y - player.position.y));
      playerBase.add(
        MoveByEffect(
            Vector2(touchPoint.x - player.position.x,
                touchPoint.y - player.position.y),
            EffectController(duration: 0.6)),
      );
      parallaxMove(touchPoint.x, touchPoint.y);

      cameraPoint.add(
        MoveByEffect(
            Vector2(touchPoint.x - player.position.x,
                touchPoint.y - player.position.y),
            EffectController(duration: 0.75)),
      );
    }
  }

  Future<void> parallaxMove(double x, double y) async {
    double ratio = 8;
    _turtleWorld.parallax?.baseVelocity = Vector2(
        (x - player.position.x) / ratio, (y - player.position.y) / ratio);

    await Future.delayed(Duration(milliseconds: 700));

    _turtleWorld.parallax?.baseVelocity = Vector2(0, 0);
  }
}

class Player extends SpriteComponent with HasGameRef, Tappable {
  static const speed = 0.25;
  static const squareSize = 200.0;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  bool isBase = false;

  Player(Vector2 position, this.isBase) : super(position: position);

  @override
  void update(double dt) {
    super.update(dt);
    // angle += speed * dt;
    // angle %= 2 * math.pi;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    SaveController save = Get.find();
    if (isBase) {
      if (save.selectedTurtle == 0) {
        sprite = await gameRef.loadSprite('turtles/template.png');
      } else {
        sprite = await gameRef.loadSprite('turtles/${save.selectedTurtle}.png');
      }
    } else {
      sprite = await gameRef.loadSprite('turtle_basic.png');
    }
    size.setValues(squareSize, squareSize);
    anchor = Anchor.center;
  }

  // @override
  // bool onTapUp(TapUpInfo info) {
  //   removeFromParent();
  //   info.handled = true;
  //   return true;
  // }
}

class CameraPoint extends SpriteComponent with HasGameRef, Tappable {
  static const speed = 0.25;
  static const squareSize = 200.0;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  CameraPoint(Vector2 position) : super(position: position);

  @override
  void update(double dt) {
    super.update(dt);
    // angle += speed * dt;
    // angle %= 2 * math.pi;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('turtle_basic.png');
    // size.setValues(squareSize, squareSize);
    anchor = Anchor.center;
  }

  // @override
  // bool onTapUp(TapUpInfo info) {
  //   removeFromParent();
  //   info.handled = true;
  //   return true;
  // }
}

class TurtleGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO: add UI overlay on top via Stack
    SaveController saveController = Get.find();

    return Stack(
      children: [
        GameWidget.controlled(gameFactory: TurtleGame.new),
        Container(
            height: 100,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                            height: 27, child: Image.asset("assets/egg.png")),
                        const SizedBox(
                          width: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                          child: Text(
                            saveController.eggs.value.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: saveController.eggs.value == 0
                                    ? Colors.grey
                                    : Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                            height: 27,
                            child: Image.asset("assets/gem_icon.png")),
                        const SizedBox(
                          width: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                          child: Text(
                            saveController.gems.value.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: saveController.gems.value == 0
                                    ? Colors.grey
                                    : Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    )),
              ],
            ))
      ],
    );
  }
}
