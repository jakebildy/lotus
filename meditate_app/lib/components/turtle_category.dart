import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/locked_turtle.dart';
import 'package:meditate_app/pages/turtle_category_page.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';

class TurtleCategory extends StatelessWidget {
  final int id;
  final bool unlocked;
  final int uniqueQuantity;
  final int displayColor;
  const TurtleCategory(
      {Key? key,
      required this.unlocked,
      required this.id,
      required this.uniqueQuantity,
      required this.displayColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: () {
        if (unlocked) {
          HapticFeedback.lightImpact();
          Get.to(TurtleCategoryPage(id: id), transition: Transition.downToUp);
        } else {
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              key: UniqueKey(),
              backgroundColor: tierColor(TURTLES[id].tier),
              content: Text(
                "This turtle can be found by ${tierReadablePlural(TURTLES[id].tier)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              )));
        }
      },
      child: Card(
          color: unlocked ? null : Colors.white10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              unlocked
                  ? Hero(
                      tag: "turtle-$id",
                      child: Stack(
                        children: [
                          Image.asset("assets/images/turtles/swim/swim1.png"),
                          id >= 0 && id < TURTLES.length
                              ? ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      TURTLE_COLORS[displayColor]
                                          .withOpacity(0.5),
                                      BlendMode.srcATop),
                                  child: Image.asset(
                                      "assets/images/turtles/$id.png"))
                              : Container(),
                          id != 10
                              ? Container()
                              : Image.asset(
                                  "assets/images/turtles/10_overlay.png"),
                        ],
                      ))
                  : LockedTurtle(
                      id: id,
                      colorId: -1,
                    ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text((TURTLES[id].name.split(" ")[0] + " Turtles"),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      Text(tierReadable(TURTLES[id].tier),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: tierColor(TURTLES[id].tier))),
                      const SizedBox(height: 20),
                      Text(
                          "${unlocked ? uniqueQuantity : '0'} of ${TURTLE_COLORS.length}",
                          style: const TextStyle(fontSize: 12))
                    ],
                  ),
                ),
              ),
              Text(
                  "${((unlocked ? uniqueQuantity : 0) / TURTLE_COLORS.length * 100).toStringAsFixed(1)}%",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: unlocked ? Colors.tealAccent : Colors.grey)),
              const SizedBox(
                width: 5,
              ),
              Icon(Icons.arrow_forward_ios,
                  color: unlocked ? Colors.tealAccent : Colors.white12),
              const SizedBox(
                width: 10,
              ),
            ],
          )),
    );
  }
}
