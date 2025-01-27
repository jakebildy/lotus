import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/particles.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditate_app/controllers/game_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/flame/components/butterfly.dart';
import 'package:meditate_app/flame/components/fish.dart';
import 'package:meditate_app/flame/components/land_objects.dart';
import 'package:meditate_app/flame/components/lilypad.dart';
import 'package:meditate_app/flame/components/other_turtle.dart';
import 'package:meditate_app/flame/components/palm_tree.dart';
import 'package:meditate_app/flame/components/palm_tree_leaf_shadow.dart';
import 'package:meditate_app/flame/components/palm_tree_shadow.dart';
import 'package:meditate_app/flame/components/rainbow_fish.dart';
import 'package:meditate_app/flame/components/rainbow_lilypad.dart';
import 'package:meditate_app/flame/components/seafloor_object.dart';
import 'package:meditate_app/flame/components/special/sand_dollar.dart';
import 'package:meditate_app/flame/components/turtle_world.dart';
import 'package:meditate_app/flame/components/wateranimation_above.dart';
import 'package:meditate_app/flame/components/treasure_chest.dart';
import 'package:meditate_app/flame/tiles/sand_tile.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';
import 'package:perlin/perlin.dart';

import 'components/wateranimation.dart';

class TurtleGame extends FlameGame with HasTappables {
  late Sprite background;
  final TurtleWorld _turtleWorld = TurtleWorld();
  late PlayerBase playerBase;
  late Player player = Player(Vector2(400, 400), false, elevation);
  CameraPoint cameraPoint = CameraPoint(Vector2(400, 400));

  List<SeaFloorObject> seafloorObjects = [];
  List<PalmTree> palmTrees = [];
  List<List<double>> palmTreeLocations = [];
  List<List<double>> seafloorObjectLocations = [];

  WaterAnimation waterAnimation = WaterAnimation(Vector2(400, 100), (700));
  WaterAnimation waterAnimation2 = WaterAnimation(Vector2(400, 800), (700));
  WaterAnimationAbove waterAnimation3 =
      WaterAnimationAbove(Vector2(400, 800), (400), 300);
  WaterAnimationAbove waterAnimation4 =
      WaterAnimationAbove(Vector2(400, 800), (400), -100);
  WaterAnimationAbove waterAnimation5 =
      WaterAnimationAbove(Vector2(400, 800), (400), -500);
  var elevation;

  // late AudioPlayer localAudioPlayer;

  Future<void> playAudio() async {
    // if (!Get.find<GameController>().playingAudio.value) {
    //   Get.find<GameController>().toggleAudio(true);

    //   String assetPath = "assets/audio/beach.mp3";
    //   localAudioPlayer = AudioPlayer();
    //   await localAudioPlayer.setAsset(assetPath);
    //   await localAudioPlayer.setLoopMode(LoopMode.all);
    //   await localAudioPlayer.setVolume(0.4);
    //   await localAudioPlayer.play();
    // }
  }

  @override
  Future<void> onLoad() async {
    // playAudio();
    add(_turtleWorld);

    double islandThreshold = 0;
    double deepWaterThreshold = -0.3;
    elevation = perlin2d(width: 200, height: 200, frequency: 10);
    playerBase = PlayerBase(Vector2(400, 400), true, elevation);
    player ==
        Player(
            Vector2(
              400,
              400,
            ),
            false,
            elevation);
    List<List<String>> terrainMap =
        List.generate(200, (_) => List.filled(200, ' '));

    for (var y = 0; y < 200; y++) {
      for (var x = 0; x < 200; x++) {
        double value = elevation[y][x]; // Scale affects the "zoom" of the noise
        terrainMap[y][x] = value > islandThreshold
            ? 'L'
            : value > deepWaterThreshold
                ? 'W'
                : 'D';
      }
    }

    for (int i = -100; i < 100; i++) {
      for (int j = -100; j < 100; j++) {
        if (terrainMap[j + 100][i + 100] == 'D') {
          // seafloorObjects.add(SeaFloorObject(Vector2(i * 50.0, j * 50.0),
          //     (50 + math.Random().nextInt(30)).toDouble()));
          if (math.Random().nextInt(15) == 1) {
            add(Lilypad(Vector2(i * 100.0, j * 100.0),
                (70 + math.Random().nextInt(30)).toDouble()));
          } else if (math.Random().nextInt(15) == 1) {
            add(RainbowLilypad(Vector2(i * 100, j * 100),
                (70 + math.Random().nextInt(30)).toDouble()));
          }
        } else if (terrainMap[j + 100][i + 100] == 'L') {
          var sandTile = SandTile(
              isAboveWater: elevation[j + 100][i + 100] > 0.3,
              isDeep: elevation[j + 100][i + 100] <= 0.1)
            ..position = Vector2(
              i * 100.0,
              j * 100.0,
            );

          if (elevation[j + 100][i + 100] > 0.3) {
            sandTile.priority = 100;
            if (math.Random().nextInt(30) == 1) {
              double palmTreeSize = 340 + math.Random().nextInt(60).toDouble();
              double angle = Random().nextDouble() * 2 * pi;
              palmTrees.add(
                  PalmTree(Vector2(i * 100.0, j * 100.0), angle, palmTreeSize));
              palmTreeLocations.add([i * 100.0, j * 100.0]);

              add(PalmTreeShadow(
                  Vector2(i * 100.0, j * 100.0), angle, (palmTreeSize)));
              add(PalmTreeLeafShadow(
                  Vector2(i * 100.0, j * 100.0), angle, (palmTreeSize)));
            } else if (math.Random().nextInt(80) == 1) {
              add(TreasureChest(Vector2(i * 100.0, j * 100.0), 70));
            } else if (math.Random().nextInt(4) == 1) {
              add(LandItems(Vector2(i * 100.0, j * 100.0),
                  (50 + math.Random().nextInt(30)).toDouble()));
            }
          } else if (elevation[j + 100][i + 100] > 0.2) {
            sandTile.opacity = 1;
            sandTile.priority = 9;
          } else if (elevation[j + 100][i + 100] > 0.1) {
            sandTile.opacity = 1; //lower
            sandTile.priority = 6;
          } else {
            sandTile.opacity = 1; //lowest
            sandTile.priority = 5;
            if (math.Random().nextInt(100) == 1) {
              add(SandDollar(Vector2(i * 100.0, j * 100.0), (30)));
            }
          }
          add(sandTile);
        } else {
          // add(DirtTile(variant: math.Random().nextInt(14))
          //   ..position = Vector2(i * 50.0, j * 50.0));
        }
      }
    }

    for (int i = 0; i < 700; i++) {
      seafloorObjects.add(SeaFloorObject(
          Vector2(math.Random().nextInt(20000).toDouble() - 10000,
              math.Random().nextInt(20000).toDouble() - 10000),
          (50 + math.Random().nextInt(30)).toDouble()));
      seafloorObjectLocations.add([
        math.Random().nextInt(20000).toDouble() - 10000,
        math.Random().nextInt(20000).toDouble() - 10000
      ]);
    }

    for (var seafloorObject in seafloorObjects) {
      add(seafloorObject);
    }

    for (int i = 0; i < 400; i++) {
      add(Fish(Vector2(math.Random().nextInt(20000).toDouble() - 10000,
          math.Random().nextInt(20000).toDouble() - 10000)));
    }

    for (int i = 0; i < 400; i++) {
      add(RainbowFish(Vector2(math.Random().nextInt(20000).toDouble() - 10000,
          math.Random().nextInt(20000).toDouble() - 10000)));
    }

    add(waterAnimation);

    add(waterAnimation2);

    for (int i = 0; i < 100; i++) {
      add(OtherTurtle(
          Vector2(math.Random().nextInt(20000).toDouble() - 10000,
              math.Random().nextInt(20000).toDouble() - 10000),
          elevation));
    }

    add(playerBase);
    add(player);

    add(cameraPoint);

    add(waterAnimation3);

    add(waterAnimation4);

    add(waterAnimation5);
    waterAnimation.priority = 8;
    waterAnimation2.priority = 9;
    waterAnimation3.priority = 10;
    waterAnimation4.priority = 11;
    waterAnimation5.priority = 12;

    //Above the player & lilypads

    for (int i = 0; i < 400; i++) {
      add(Butterfly(Vector2(math.Random().nextInt(20000).toDouble() - 10000,
          math.Random().nextInt(20000).toDouble() - 10000)));
    }

    for (var palmTree in palmTrees) {
      add(palmTree);
    }

    camera.followComponent(cameraPoint);
  }

  bool canMove = true;

  debounceCanMove() async {
    canMove = false;
    await Future.delayed(const Duration(milliseconds: 620));
    canMove = true;
  }

  AudioPlayer splash = AudioPlayer();

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);

    if (!info.handled && canMove) {
      debounceCanMove();
      if (playerBase.priority < 100) {
        splash.setAsset('assets/audio/splash.wav');
        splash.play();

        HapticFeedback.lightImpact();
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
              EffectController(
                duration: 0.6,
              )),
        );
        playerBase.angle = math.atan2(
            borderX - player.position.x, -1 * (borderY - player.position.y));
        playerBase.add(
          MoveByEffect(
              Vector2(borderX - player.position.x, borderY - player.position.y),
              EffectController(duration: 0.6)),
        );
        swimAnimation(playerBase);
        swimParticles();

        parallaxMove(borderX, borderY);

        cameraPoint.add(
          MoveByEffect(
              Vector2(borderX - player.position.x, borderY - player.position.y),
              EffectController(duration: 0.75)),
        );
      } else {
        splash = AudioPlayer();
        splash.setAsset('assets/audio/sand.wav');
        splash.play();

        HapticFeedback.lightImpact();
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
              Vector2((borderX - player.position.x) / 1,
                  (borderY - player.position.y) / 1),
              EffectController(
                duration: 0.6,
              )),
        );
        playerBase.angle = math.atan2(
            borderX - player.position.x, -1 * (borderY - player.position.y));
        playerBase.add(
          MoveByEffect(
              Vector2((borderX - player.position.x) / 1,
                  (borderY - player.position.y) / 1),
              EffectController(duration: 0.6)),
        );
        swimAnimation(playerBase);

        parallaxMove(borderX, borderY);

        cameraPoint.add(
          MoveByEffect(
              Vector2((borderX - player.position.x) / 1,
                  (borderY - player.position.y) / 1),
              EffectController(duration: 0.75)),
        );
      }
    }
  }

  // on game ended

  @override
  void onDetach() {
    super.onDetach();

    // localAudioPlayer.stop();
    splash.dispose();
    // Get.find<GameController>().toggleAudio(false);
  }

  Future<void> swimParticles() async {
    Random rnd = Random();

    Vector2 randomVector2() =>
        (Vector2.random(rnd) - Vector2.random(rnd)) * 400;

    for (int i = 0; i < 4; i++) {
      add(
        ParticleSystemComponent(
          particle: Particle.generate(
            count: 40,
            generator: (i) => AcceleratedParticle(
              // make it change color over time

              acceleration: randomVector2(),
              position: player.position.clone() + Vector2(-30, -40),
              child: CircleParticle(
                paint: Paint()..color = const Color.fromARGB(7, 255, 255, 255),
              ),
            ),
          ),
          priority: 0,
        ),
      );

      add(
        ParticleSystemComponent(
          particle: Particle.generate(
            count: 40,
            generator: (i) => AcceleratedParticle(
              acceleration: randomVector2(),
              position: player.position.clone() + Vector2(30, -40),
              child: CircleParticle(
                paint: Paint()..color = const Color.fromARGB(7, 255, 255, 255),
              ),
            ),
          ),
          priority: 0,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 50));
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
        (x - player.position.x) / ratio * 2,
        (y - player.position.y) / ratio * 2);

    // For all SeafloorObjects, add parallax
    for (int i = 0; i < seafloorObjects.length; i++) {
      if (seafloorObjects[i].position.distanceTo(player.position) < 600) {
        seafloorObjects[i].add(
          MoveByEffect(
              Vector2((x - player.position.x) / (ratio / 4),
                  (y - player.position.y) / (ratio / 4)),
              EffectController(duration: 0.6, curve: Curves.linear)),
        );
      } else {
        seafloorObjects[i].position = Vector2(
            seafloorObjectLocations[i][0], seafloorObjectLocations[i][1]);
      }
    }

    for (int i = 0; i < palmTrees.length; i++) {
      if (palmTrees[i].position.distanceTo(player.position) < 600) {
        palmTrees[i].add(
          MoveByEffect(
              Vector2((x - player.position.x) * -0.2,
                  (y - player.position.y) * -0.2),
              EffectController(duration: 0.6, curve: Curves.linear)),
        );
      } else {
        palmTrees[i].position =
            Vector2(palmTreeLocations[i][0], palmTreeLocations[i][1]);
      }
    }

    waterAnimation.add(
      MoveByEffect(Vector2((x - player.position.x), (y - player.position.y)),
          EffectController(duration: 0.6, curve: Curves.linear)),
    );

    waterAnimation2.add(
      MoveByEffect(Vector2((x - player.position.x), (y - player.position.y)),
          EffectController(duration: 0.6, curve: Curves.linear)),
    );

    waterAnimation3.add(
      MoveByEffect(Vector2((x - player.position.x), (y - player.position.y)),
          EffectController(duration: 0.6, curve: Curves.linear)),
    );

    waterAnimation4.add(
      MoveByEffect(Vector2((x - player.position.x), (y - player.position.y)),
          EffectController(duration: 0.6, curve: Curves.linear)),
    );

    waterAnimation5.add(
      MoveByEffect(Vector2((x - player.position.x), (y - player.position.y)),
          EffectController(duration: 0.6, curve: Curves.linear)),
    );

    await Future.delayed(const Duration(milliseconds: 600));

    _turtleWorld.parallax?.baseVelocity = Vector2(
        (-1 * x - player.position.x) / (ratio * 10),
        (-1 * y - player.position.y) / (ratio * 10));
    await Future.delayed(const Duration(milliseconds: 50));
    _turtleWorld.parallax?.baseVelocity = Vector2(0, 0);
  }
}

class Player extends SpriteAnimationComponent with HasGameRef, Tappable {
  static const speed = 0.25;
  static const squareSize = 200.0;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  bool isBase = false;
  List<List<double>> elevation;

  Player(Vector2 position, this.isBase, this.elevation)
      : super(position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    GameController game = Get.find();

    if (!isBase) {
      // TODO: crystal turtle

      if (game.selectedTurtle.value == 21) {
        Sprite underlay = await gameRef.loadSprite(
          'turtles/21_underlay.png',
        );

        add(SpriteComponent(
            sprite: underlay,
            priority: 101,
            size: Vector2(squareSize, squareSize),
            anchor: Anchor.center));
      }
      Sprite sprite =
          await gameRef.loadSprite('turtles/${game.selectedTurtle}.png');
      paint = Paint()
        ..colorFilter = ColorFilter.mode(
            TURTLE_COLORS[game.turtleColor.value].withOpacity(0.4),
            BlendMode.srcATop);

      add(SpriteComponent(
          sprite: sprite,
          paint: paint,
          priority: 102,
          size: Vector2(squareSize, squareSize),
          anchor: Anchor.center));

      if (game.turtleColor.value == 18) {
        if (game.selectedTurtle.value != 10) {
          Sprite sprite =
              await gameRef.loadSprite('turtles/overlay_rainbow_default.png');

          add(SpriteComponent(
              sprite: sprite,
              priority: 104,
              size: Vector2(squareSize, squareSize),
              anchor: Anchor.center));
        } else {
          Sprite sprite = await gameRef.loadSprite(
            'turtles/overlay_rainbow_crystal.png',
          );

          add(SpriteComponent(
              sprite: sprite,
              priority: 105,
              size: Vector2(squareSize, squareSize),
              anchor: Anchor.center));
        }
      }
      if (game.selectedTurtle.value == 10) {
        Sprite overlay = await gameRef.loadSprite(
          'turtles/10_overlay.png',
        );

        add(SpriteComponent(
            sprite: overlay,
            priority: 105,
            size: Vector2(squareSize, squareSize),
            anchor: Anchor.center));
      }

      if (game.selectedTurtle.value == 23) {
        Sprite overlay = await gameRef.loadSprite(
          'turtles/23_overlay.png',
        );

        add(SpriteComponent(
            sprite: overlay,
            priority: 105,
            size: Vector2(squareSize, squareSize),
            anchor: Anchor.center));
      }
    } else {
      Sprite turtleBasic = await gameRef.loadSprite('turtle_basic.png');
      add(SpriteComponent(
          sprite: turtleBasic,
          size: Vector2(squareSize, squareSize),
          anchor: Anchor.center));

      // size.setValues(squareSize, squareSize);
      anchor = Anchor.center;
    }
  }

  // update
  @override
  void update(double dt) {
    super.update(dt);
    if (position.y ~/ 100 + 100 > elevation.length) {
      return;
    }
    if (position.x ~/ 100 + 100 > elevation[0].length) {
      return;
    }
    if (elevation[position.y ~/ 100 + 100][position.x ~/ 100 + 100] > 0.1) {
      priority = 104;
    } else {
      priority = 10;
    }
  }
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
  List<List<double>> elevation;

  PlayerBase(Vector2 position, this.isBase, this.elevation)
      : super(
          position: position,
        );

  @override
  void update(double dt) {
    super.update(dt);
    if (position.y ~/ 100 + 100 > elevation.length) {
      return;
    }
    if (position.x ~/ 100 + 100 > elevation[0].length) {
      return;
    }
    if (elevation[position.y ~/ 100 + 100][position.x ~/ 100 + 100] > 0.1) {
      priority = 103;
    } else {
      priority = 9;
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    if (position.y ~/ 100 + 100 > elevation.length) {
      return;
    }
    if (position.x ~/ 100 + 100 > elevation[0].length) {
      return;
    }
    if (elevation[position.y ~/ 100 + 100][position.x ~/ 100 + 100] > 0.1) {
      priority = 103;
    } else {
      priority = 9;
    }
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
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 32.0, 0),
            child: SizedBox(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Level " +
                      calculateLevel(
                              user.user.value.levelPoints, user.user.value)
                          .toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            )),
          ),
        )
      ],
    );
  }
}
