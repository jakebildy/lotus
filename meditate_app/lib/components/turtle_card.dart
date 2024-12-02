import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/locked_turtle.dart';
import 'package:meditate_app/pages/turtle_details_page.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';
import 'package:shimmer/shimmer.dart';

class TurtleCard extends StatelessWidget {
  final int id;
  final bool unlocked;
  final int color;
  final int quantity;
  const TurtleCard(
      {Key? key,
      required this.unlocked,
      required this.id,
      required this.color,
      required this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: () {
        if (unlocked) {
          PostHogService posthog = Get.find();
          posthog.logEvent("TURTLE_CARD_UNLOCKED_TAPPED", {});
          HapticFeedback.lightImpact();
          Get.to(TurtleDetailsPage(id: id, color: color),
              transition: Transition.downToUp);
        } else {
          PostHogService posthog = Get.find();
          posthog.logEvent("TURTLE_CARD_LOCKED_TAPPED", {});
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).clearSnackBars();

          if (this.color == 18) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                key: UniqueKey(),
                backgroundColor: Colors.deepPurpleAccent,
                content: const Text(
                  "This turtle can be found once you reach Rainbow Flame (40+ minutes a day of meditation)!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                key: UniqueKey(),
                backgroundColor: TURTLES[id].name == "Litback Turtle"
                    ? Colors.deepPurpleAccent
                    : TURTLES[id].foundIn != null
                        ? Colors.tealAccent
                        : rarityColor(TURTLES[id].rarity),
                content: Text(
                  TURTLES[id].name == "Aether Turtle"
                      ? "This turtle can be found when doing breathwork!"
                      : TURTLES[id].name == "Litback Turtle"
                          ? "This social turtle can be found once you add at least one friend on Shellevate!"
                          : TURTLES[id].foundIn != null
                              ? "Meditate with the ${TURTLES[id].foundIn!.name} Ambience to find this turtle!"
                              : "This " +
                                  rarityReadable(TURTLES[id].rarity) +
                                  " Turtle can be found by Level ${TURTLES[id].level} users and above!",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )));
          }
        }
      },
      child: Card(
          color: unlocked ? null : Colors.transparent,
          // elevation: unlocked ? null : 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              unlocked
                  ? Hero(
                      tag: "turtle-$id",
                      child: Stack(
                        children: [
                          Image.asset("assets/images/turtles/swim/swim1.png"),
                          id != 21
                              ? Container()
                              : Image.asset(
                                  "assets/images/turtles/21_underlay.png"),
                          id >= 0 && id < TURTLES.length
                              ? (color == 18
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
                                          TURTLE_COLORS[color].withOpacity(0.5),
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
                        colorId: color,
                      ),
                      TURTLES[id].tier == Tier.RAINBOW
                          ? Shimmer.fromColors(
                              baseColor: Colors.white12,
                              highlightColor: Colors.white30,
                              child: LockedTurtle(
                                id: id,
                                colorId: color,
                              ),
                            )
                          : Container()
                    ]),

              // SizedBox(
              //   width: 10,
              // ),
              // Expanded(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 8.0),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text((TURTLE_COLORS_NAME[color] + " " + TURTLES[id].name),
              //             style: TextStyle(
              //                 fontSize: 15, fontWeight: FontWeight.w600)),
              //         Text("${quantity} found",
              //             style: TextStyle(
              //                 fontSize: 14,
              //                 color: quantity > 0
              //                     ? Colors.tealAccent
              //                     : Colors.grey))
              //       ],
              //     ),
              //   ),
              // ),
              // Icon(Icons.arrow_forward_ios),
              // SizedBox(
              //   width: 10,
              // )
            ],
          )),
    );
  }
}
