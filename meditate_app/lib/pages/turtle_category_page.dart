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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(TURTLES[id].name + "s"),
            Text(
              tierReadable(TURTLES[id].tier),
              style:
                  TextStyle(color: tierColor(TURTLES[id].tier), fontSize: 14),
            )
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
                  unlocked: user.user.value.unlockedTurtles[id] != 0 &&
                      user.user.value.unlockedTurtleColors[id].contains(index),
                  // set quantity equal to the length of unlockedTurleColors[id] filtered to only the ones that contain the index
                  quantity: user.user.value.unlockedTurtleColors[id]
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
