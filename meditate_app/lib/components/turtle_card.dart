import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/pages/turtle_details_page.dart';
import 'package:meditate_app/util/turtles.dart';

class TurtleCard extends StatelessWidget {
  final int id;
  final bool unlocked;
  const TurtleCard({Key? key, required this.unlocked, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (unlocked) {
          Get.to(TurtleDetailsPage(id: id), transition: Transition.downToUp);
        }
      },
      child: Card(
          child: unlocked
              ? Hero(
                  tag: "turtle-${id}",
                  child: Stack(
                    children: [
                      Image.asset("assets/turtles/0.png"),
                      id > 0 && id < TURTLES.length
                          ? Image.asset("assets/turtles/${id}.png")
                          : Container(),
                    ],
                  ))
              : Image.asset("assets/turtles/locked.png")),
    );
  }
}
