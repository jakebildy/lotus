import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meditate_app/components/turtle_card.dart';
import 'package:meditate_app/components/turtle_card.dart';
import 'package:meditate_app/components/turtle_category.dart';
import 'package:meditate_app/util/turtles.dart';

class TurtleCategoryPage extends StatelessWidget {
  final int id;
  const TurtleCategoryPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
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
                      true, //FOR TESTING PURPOSES ONLY --> TODO: readd Obx
                  color: index,
                  id: id),
            );
          })),
    );
  }
}
