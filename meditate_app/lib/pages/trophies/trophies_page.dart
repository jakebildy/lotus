import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/level_progress_bar.dart';
import 'package:meditate_app/components/turtle_image.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/trophies/trophy_widget.dart';
import 'package:meditate_app/util/turtles.dart';
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
            title: const Text("Collections"),
          ),
          backgroundColor: Colors.grey[900],
          bottomNavigationBar: SafeArea(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              Text(
                "Level " +
                    calculateLevel(user.user.value.levelPoints).toString() +
                    " (${user.user.value.levelPoints} XP)",
                style: const TextStyle(color: Colors.white),
              ),
              const LevelProgressBar(),
            ],
          )),
          body: ListView(
            children: [
              const TrophyWidget(title: "Origins", xp: 20, turtles: [
                [0, 0],
                [1, 0],
              ]),
              const TrophyWidget(title: "Honey", xp: 20, turtles: [
                [15, 4],
                [15, 15],
              ]),
              const TrophyWidget(title: "Coffee", xp: 20, turtles: [
                [3, 0],
                [8, 17],
              ]),
              const TrophyWidget(title: "Fire Portal", xp: 40, turtles: [
                [4, 12],
                [6, 2],
                [7, 1],
                [17, 4]
              ]),
              const TrophyWidget(title: "Celestial Harmony", xp: 100, turtles: [
                [9, 4],
                [19, 16],
                [20, 9],
                [20, 6]
              ]),
              const TrophyWidget(title: "Fruit Salad", xp: 50, turtles: [
                [14, 13],
                [16, 6],
                [15, 5],
                [16, 3],
              ]),
              const TrophyWidget(
                  title: "Floating Cities on Venus",
                  xp: 100,
                  turtles: [
                    [23, 9],
                    [9, 17],
                    [8, 12],
                    [4, 10]
                  ]),
              const TrophyWidget(
                  title: "Yearning for Mines",
                  xp: 200,
                  turtles: [
                    [1, 15],
                    [1, 16],
                    [10, 18],
                    [4, 15]
                  ]),

              // for all turtles, create a trophy widget for collecting all colors of it
              ...List.generate(
                  TURTLES.length,
                  (i) => TrophyWidget(
                      title: TURTLES[i].name + " Set",
                      xp: 500 +
                          50 * TURTLES[i].level +
                          50 * TURTLES[i].rarity.index,
                      turtles:
                          List.generate(TURTLE_COLORS.length, (j) => [i, j])))
            ],
          )),
    );
  }
}
