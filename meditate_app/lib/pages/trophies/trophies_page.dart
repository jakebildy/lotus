import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/level_progress_bar.dart';
import 'package:meditate_app/components/turtle_image.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/trophies/trophy_widget.dart';
import 'package:meditate_app/util/util.dart';

class TrophyPage extends StatelessWidget {
  const TrophyPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();

    return Obx(
      () => Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey[900],
            title: const Text("Trophies"),
          ),
          backgroundColor: Colors.grey[900],
          bottomNavigationBar: SafeArea(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(),
              Text(
                "Level " +
                    calculateLevel(user.user.value.levelPoints).toString() +
                    " (${user.user.value.levelPoints} XP)",
                style: const TextStyle(color: Colors.white),
              ),
              LevelProgressBar(),
            ],
          )),
          body: ListView(
            children: const [
              TrophyWidget(
                  title: "Into the Fire",
                  description:
                      "Collect a Litback Turtle, a Nether Turtle and a Magma Turtle",
                  xp: 40,
                  turtles: [
                    [6, 2],
                    [7, 1],
                    [17, 4]
                  ]),
              TrophyWidget(
                  title: "Celestial Harmony",
                  description:
                      "Collect a Yellow Sun Turtle, a Grey Luna Turtle, a Blue World Turtle and a Green World Turtle",
                  xp: 100,
                  turtles: [
                    [9, 4],
                    [19, 16],
                    [20, 9],
                    [20, 6]
                  ])
            ],
          )),
    );
  }
}
