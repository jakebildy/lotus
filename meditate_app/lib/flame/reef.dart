import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/particles.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/flame/components/butterfly.dart';
import 'package:meditate_app/flame/components/fish.dart';
import 'package:meditate_app/flame/components/lilypad.dart';
import 'package:meditate_app/flame/components/rainbow_lilypad.dart';
import 'package:meditate_app/flame/components/reef_turtle.dart';
import 'package:meditate_app/flame/components/reef_world.dart';
import 'package:meditate_app/flame/components/seafloor_object.dart';

import 'components/wateranimation.dart';

class ReefGame extends FlameGame with HasTappables {
  late Sprite background;

  List<SeaFloorObject> seafloorObjects = [];
  WaterAnimation waterAnimation = WaterAnimation(Vector2(100, 100), (700));
  WaterAnimation waterAnimation2 = WaterAnimation(Vector2(100, 800), (700));
  WaterAnimation waterAnimation3 = WaterAnimation(Vector2(100, 100), (700));
  WaterAnimation waterAnimation4 = WaterAnimation(Vector2(100, 800), (700));
  final ReefWorld _reefWorld = ReefWorld();

  @override
  Future<void> onLoad() async {
    add(_reefWorld);
    for (int i = 0; i < 10; i++) {
      seafloorObjects.add(SeaFloorObject(
          Vector2(math.Random().nextInt(400).toDouble(),
              math.Random().nextInt(800).toDouble()),
          (20 + math.Random().nextInt(15)).toDouble()));
    }

    for (var seafloorObject in seafloorObjects) {
      add(seafloorObject);
    }

    // for (int i = 0; i < 10; i++) {
    //   add(Fish(Vector2(math.Random().nextInt(400).toDouble(),
    //       math.Random().nextInt(800).toDouble())));
    // }

    add(waterAnimation);
    add(waterAnimation2);
    add(waterAnimation3);
    add(waterAnimation4);

    UserController user = Get.find();

    for (int i = 0; i < user.user.value.unlockedTurtleColors.length; i++) {
      for (int j = 0; j < user.user.value.unlockedTurtleColors[i].length; j++) {
        add(ReefTurtle(
          Vector2(math.Random().nextInt(400).toDouble(),
              math.Random().nextInt(800).toDouble()),
          i,
          user.user.value.unlockedTurtleColors[i][j],
        ));
      }
    }
  }

  bool canMove = true;

  debounceCanMove() async {
    canMove = false;
    await Future.delayed(const Duration(milliseconds: 620));
    canMove = true;
  }
}

class ReefPage extends StatefulWidget {
  const ReefPage({super.key});

  @override
  State<ReefPage> createState() => _ReefPageState();
}

class _ReefPageState extends State<ReefPage> {
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
        const GameWidget.controlled(gameFactory: ReefGame.new),
      ],
    );
  }
}
