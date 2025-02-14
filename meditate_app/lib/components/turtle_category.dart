import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/locked_turtle.dart';
import 'package:meditate_app/components/piechart_painter.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/turtle_category_page.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';
import 'package:shimmer/shimmer.dart';

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
    UserController userController = Get.find<UserController>();

    return Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: () {
        HapticFeedback.lightImpact();

        PostHogService posthog = Get.find();
        posthog.logEvent("TURTLE_CATEGORY_TAPPED", {});

        Get.to(TurtleCategoryPage(id: id), transition: Transition.downToUp);
        // if (unlocked) {
        //   HapticFeedback.lightImpact();
        //   Get.to(TurtleCategoryPage(id: id), transition: Transition.downToUp);
        // } else {
        //   HapticFeedback.lightImpact();
        //   ScaffoldMessenger.of(context).clearSnackBars();
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       key: UniqueKey(),
        //       backgroundColor: TURTLES[id].name == "Litback Turtle"
        //           ? Colors.deepPurpleAccent
        //           : TURTLES[id].foundIn != null
        //               ? Colors.tealAccent
        //               : tierColor(TURTLES[id].tier),
        //       content: Text(
        //         TURTLES[id].name == "Litback Turtle"
        //             ? "This social turtle can be found once you add at least one friend on Shellevate!"
        //             : TURTLES[id].foundIn != null
        //                 ? "Meditate with the ${TURTLES[id].foundIn!.name} Ambience to find this turtle!"
        //                 : "This turtle can be found by ${tierReadablePlural(TURTLES[id].tier)}",
        //         style: const TextStyle(fontWeight: FontWeight.bold),
        //       )));
        // }
      },
      child: Card(
          color: unlocked ? null : Colors.white10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              unlocked
                  ? Hero(
                      tag: "turtle-$id-$displayColor",
                      child: Stack(
                        children: [
                          Image.asset("assets/images/turtles/swim/swim1.png"),
                          id != 21
                              ? Container()
                              : Image.asset(
                                  "assets/images/turtles/21_underlay.png"),
                          id >= 0 && id < TURTLES.length
                              ? (displayColor == 18
                                  ? ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                          colors: [
                                            Colors.red.withOpacity(0.5),
                                            Colors.red.withOpacity(0.5),
                                            Colors.orange.withOpacity(0.5),
                                            Colors.yellow.withOpacity(0.5),
                                            Colors.green.withOpacity(0.5),
                                            Colors.blue.withOpacity(0.5),
                                            Colors.indigo.withOpacity(0.5),
                                            Colors.purple.withOpacity(0.5),
                                            Colors.purple.withOpacity(0.5),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ).createShader(bounds);
                                      },
                                      blendMode: BlendMode.srcATop,
                                      child: Image.asset(
                                          "assets/images/turtles/$id.png"),
                                    )
                                  : ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          TURTLE_COLORS[displayColor]
                                              .withOpacity(0.5),
                                          BlendMode.srcATop),
                                      child: Image.asset(
                                          "assets/images/turtles/$id.png"),
                                    ))
                              : Container(),
                          id != 10
                              ? Container()
                              : Image.asset(
                                  "assets/images/turtles/10_overlay.png"),
                          id != 23
                              ? Container()
                              : Image.asset(
                                  "assets/images/turtles/23_overlay.png"),
                        ],
                      ))
                  : Stack(children: [
                      LockedTurtle(
                        id: id,
                        colorId:
                            id % (TURTLE_COLORS.length - 1), //-1 bc rainbow
                      ),
                      TURTLES[id].tier == Tier.RAINBOW
                          ? Shimmer.fromColors(
                              baseColor: Colors.white12,
                              highlightColor: Colors.white30,
                              child: LockedTurtle(id: id, colorId: 18),
                            )
                          : Container()
                    ]),
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
                      Row(
                        children: [
                          Text(rarityReadable(TURTLES[id].rarity),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: rarityColor(TURTLES[id].rarity),
                              )),
                          TURTLES[id].level <=
                                      calculateLevel(
                                          userController.user.value.levelPoints,
                                          userController.user.value) &&
                                  TURTLES[id].foundIn == null &&
                                  TURTLES[id].tier != Tier.LITBACK &&
                                  TURTLES[id].name != "Aether Turtle"
                              ? Container()
                              : const Text(" • "),
                          TURTLES[id].level <=
                                  calculateLevel(
                                      userController.user.value.levelPoints,
                                      userController.user.value)
                              ? Container()
                              : const Icon(Icons.lock,
                                  color: Colors.grey, size: 15),
                          TURTLES[id].level <=
                                      calculateLevel(
                                          userController.user.value.levelPoints,
                                          userController.user.value) &&
                                  TURTLES[id].foundIn == null &&
                                  TURTLES[id].tier != Tier.LITBACK &&
                                  TURTLES[id].name != "Aether Turtle"
                              ? Container()
                              : Text(
                                  TURTLES[id].name == "Aether Turtle"
                                      ? "Breathwork"
                                      : TURTLES[id].name == "Litback Turtle"
                                          ? "Add Friends to Find"
                                          : TURTLES[id].foundIn != null
                                              ? "${TURTLES[id].foundIn!.name}"
                                              : "Level " +
                                                  TURTLES[id].level.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                          "${unlocked ? (uniqueQuantity + (id == 0 ? 1 : 0)) : '0'} of ${TURTLE_COLORS.length}",
                          style: const TextStyle(fontSize: 12))
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                    width: 50,
                  ),
                  CustomPaint(
                    size: const Size(10, 10), // Size of the pie chart
                    painter: PieChartPainter(
                      percentage:
                          (unlocked ? uniqueQuantity + (id == 0 ? 1 : 0) : 0) /
                              TURTLE_COLORS.length *
                              100,
                      fillColor: Colors.tealAccent,
                      backgroundColor: Colors.black12,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      " ${((unlocked ? uniqueQuantity + (id == 0 ? 1 : 0) : 0) / TURTLE_COLORS.length * 100).toStringAsFixed(0)}%",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: unlocked ? Colors.tealAccent : Colors.grey)),
                ],
              ),
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
