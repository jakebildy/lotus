import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/pages/turtle_details_page.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';

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
          HapticFeedback.lightImpact();
          Get.to(TurtleDetailsPage(id: id), transition: Transition.downToUp);
        } else {
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              key: UniqueKey(),
              backgroundColor: Colors.greenAccent,
              content: Text(
                  "This turtle can be found by ${tierReadablePlural(TURTLES[id].tier)}")));
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
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/turtles/locked.png"),
                    Text(
                      "?",
                      style: TextStyle(
                          color: Colors.grey[850],
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )),
    );
  }
}
