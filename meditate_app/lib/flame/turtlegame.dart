import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/game_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/flame/components/butterfly.dart';
import 'package:meditate_app/flame/components/fish.dart';
import 'package:meditate_app/flame/components/lilypad.dart';
import 'package:meditate_app/flame/components/other_turtle.dart';
import 'package:meditate_app/flame/components/turtle_world.dart';
import 'package:meditate_app/util/turtles.dart';

class TurtleGame extends FlameGame with HasTappables {
  late Sprite background;
  final TurtleWorld _turtleWorld = TurtleWorld();
  PlayerBase playerBase = PlayerBase(
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
    // FlameAudio.loopLongAudio('water_sounds.wav', volume: 0.5);
    add(_turtleWorld);

    for (int i = 0; i < 400; i++) {
      add(Fish(Vector2(math.Random().nextInt(20000).toDouble() - 10000,
          math.Random().nextInt(20000).toDouble() - 10000)));
    }

    for (int i = 0; i < 100; i++) {
      add(OtherTurtle(
        Vector2(math.Random().nextInt(20000).toDouble() - 10000,
            math.Random().nextInt(20000).toDouble() - 10000),
      ));
    }

    add(playerBase);
    add(player);

    add(cameraPoint);

    // for (int i = 0; i < 100; i++) {
    //   add(Rock(
    //       Vector2(math.Random().nextInt(2000).toDouble(),
    //           math.Random().nextInt(20000).toDouble()),
    //       (70 + math.Random().nextInt(60)).toDouble()));
    // }

    for (int i = 0; i < 1600; i++) {
      add(Lilypad(
          Vector2(math.Random().nextInt(20000).toDouble() - 10000,
              math.Random().nextInt(20000).toDouble() - 10000),
          (70 + math.Random().nextInt(30)).toDouble()));
    }

    //Above the player & lilypads

    for (int i = 0; i < 400; i++) {
      add(Butterfly(Vector2(math.Random().nextInt(20000).toDouble() - 10000,
          math.Random().nextInt(20000).toDouble() - 10000)));
    }

    camera.followComponent(cameraPoint);
  }

  bool canMove = true;

  debounceCanMove() async {
    canMove = false;
    await Future.delayed(const Duration(milliseconds: 620));
    canMove = true;
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);

    if (!info.handled && canMove) {
      debounceCanMove();
      FlameAudio.play('splash.wav');
      final touchPoint = info.eventPosition.game;

      double borderX = touchPoint.x > 10000
          ? 10000
          : touchPoint.x < -10000
              ? -10000
              : touchPoint.x;
      double borderY = touchPoint.y > 10000
          ? 10000
          : touchPoint.y < -10000
              ? -10000
              : touchPoint.y;

      player.angle = math.atan2(
          borderX - player.position.x, -1 * (borderY - player.position.y));

      player.add(
        MoveByEffect(
            Vector2(borderX - player.position.x, borderY - player.position.y),
            EffectController(duration: 0.6)),
      );
      playerBase.angle = math.atan2(
          borderX - player.position.x, -1 * (borderY - player.position.y));
      playerBase.add(
        MoveByEffect(
            Vector2(borderX - player.position.x, borderY - player.position.y),
            EffectController(duration: 0.6)),
      );
      swimAnimation(playerBase);
      parallaxMove(borderX, borderY);

      cameraPoint.add(
        MoveByEffect(
            Vector2(borderX - player.position.x, borderY - player.position.y),
            EffectController(duration: 0.75)),
      );
    }
  }

  Future<void> swimAnimation(SpriteGroupComponent playerBase) async {
    playerBase.current = PlayerState.swimming;
    await Future.delayed(const Duration(milliseconds: 500));
    playerBase.current = PlayerState.idle;
  }

  Future<void> parallaxMove(double x, double y) async {
    double ratio = 8;
    _turtleWorld.parallax?.baseVelocity = Vector2(
        (x - player.position.x) / ratio, (y - player.position.y) / ratio);

    await Future.delayed(const Duration(milliseconds: 700));

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
  Future<void> onLoad() async {
    super.onLoad();
    GameController game = Get.find();
    if (!isBase) {
      sprite = await gameRef.loadSprite('turtles/${game.selectedTurtle}.png');
      paint = Paint()
        ..colorFilter = ColorFilter.mode(
            TURTLE_COLORS[game.turtleColor.value].withOpacity(0.4),
            BlendMode.srcATop);
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

enum PlayerState {
  idle,
  swimming,
}

class PlayerBase extends SpriteGroupComponent<PlayerState>
    with HasGameRef, Tappable {
  static const speed = 0.25;
  static const squareSize = 200.0;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  bool isBase = false;

  PlayerBase(Vector2 position, this.isBase) : super(position: position);

  // @override
  // void update(double dt) {
  //   super.update(dt);
  // }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final idleSprite = await gameRef.loadSprite("turtles/swim/swim1.png");
    final swimSprite = await gameRef.loadSprite("turtles/swim/swim2.png");

    sprites = {
      PlayerState.idle: idleSprite,
      PlayerState.swimming: swimSprite,
    };

    current = PlayerState.idle;
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
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('turtle_basic.png');
    size.setValues(0, 0);
    anchor = Anchor.center;
  }

  // @override
  // bool onTapUp(TapUpInfo info) {
  //   removeFromParent();
  //   info.handled = true;
  //   return true;
  // }
}

class TurtleGamePage extends StatefulWidget {
  const TurtleGamePage({super.key});

  @override
  State<TurtleGamePage> createState() => _TurtleGamePageState();
}

class _TurtleGamePageState extends State<TurtleGamePage> {
  @override
  void initState() {
    //todo: pass the context so we can do alerts
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();

    return Stack(
      children: [
        const GameWidget.controlled(gameFactory: TurtleGame.new),
        SizedBox(
            height: 100,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 27, child: Image.asset("assets/egg.png")),
                        const SizedBox(
                          width: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                          child: Text(
                            user.user.value.eggs.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: user.user.value.eggs == 0
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
                        SizedBox(
                            height: 27,
                            child: Image.asset("assets/sand_dollar.png")),
                        const SizedBox(
                          width: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                          child: Text(
                            user.user.value.gems.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: user.user.value.gems == 0
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
