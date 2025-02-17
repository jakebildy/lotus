import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/turtle_card.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/turtles.dart';

import '../util/util.dart';

class TurtleCategoryPage extends StatelessWidget {
  final int id;
  const TurtleCategoryPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(TURTLES[id].name + "s"),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(rarityReadable(TURTLES[id].rarity),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: rarityColor(TURTLES[id].rarity),
                      )),
                  TURTLES[id].level <=
                              calculateLevel(user.user.value.levelPoints,
                                  user.user.value) &&
                          TURTLES[id].foundIn == null &&
                          TURTLES[id].tier != Tier.LITBACK &&
                          TURTLES[id].name != "Aether Turtle"
                      ? Container()
                      : const Text(" • "),
                  TURTLES[id].level <=
                          calculateLevel(
                              user.user.value.levelPoints, user.user.value)
                      ? Container()
                      : const Icon(Icons.lock, color: Colors.grey, size: 15),
                  TURTLES[id].level <=
                              calculateLevel(user.user.value.levelPoints,
                                  user.user.value) &&
                          TURTLES[id].foundIn == null &&
                          TURTLES[id].tier != Tier.LITBACK &&
                          TURTLES[id].name != "Aether Turtle"
                      ? Container()
                      : Text(
                          TURTLES[id].name == "Litback Turtle"
                              ? "Add Friends to Find"
                              : TURTLES[id].name == "Aether Turtle"
                                  ? "Breathwork"
                                  : TURTLES[id].foundIn != null
                                      ? TURTLES[id].foundIn!.name
                                      : "Level " + TURTLES[id].level.toString(),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                ]),
          ],
        ),
      ),
      body: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 8.0,
          children: List.generate(TURTLE_COLORS.length, (index) {
            return Center(
              child: TurtleCard(
                  unlocked: id == 0 && index == 0 ||
                      user.user.value.unlockedTurtles.length >= id &&
                          user.user.value.unlockedTurtles[id] != 0 &&
                          user.user.value.unlockedTurtleColors[id]
                              .contains(index),
                  // set quantity equal to the length of unlockedTurleColors[id] filtered to only the ones that contain the index
                  quantity: user.user.value.unlockedTurtleColors.length <= id
                      ? 0
                      : user.user.value.unlockedTurtleColors[id]
                          .where((element) => element == index)
                          .toList()
                          .length,
                  color: index,
                  id: id),
            );
          })),
    );
  }
}
