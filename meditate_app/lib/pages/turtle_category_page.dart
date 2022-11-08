import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/turtle_card.dart';
import 'package:meditate_app/components/turtle_card.dart';
import 'package:meditate_app/components/turtle_category.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/util/turtles.dart';

class TurtleCategoryPage extends StatelessWidget {
  final int id;
  const TurtleCategoryPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    SaveController saveController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text(TURTLES[id].name + "s"),
      ),
      body: GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 4,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 8.0,
          children: List.generate(TURTLE_COLORS.length, (index) {
            return Center(
              child: TurtleCard(
                  unlocked:
                      saveController.unlockedTurtleColors[id].contains(index),
                  // set quantity equal to the length of unlockedTurleColors[id] filtered to only the ones that contain the index
                  quantity: saveController.unlockedTurtleColors[id]
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
