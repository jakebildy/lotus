import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/locked_turtle.dart';
import 'package:meditate_app/pages/turtle_details_page.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:shimmer/shimmer.dart';

class TurtleCardNew extends StatelessWidget {
  final int id;
  final bool unlocked;
  final int color;
  final int quantity;
  const TurtleCardNew(
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
        }
      },
      child: Card(
          color: unlocked ? null : Colors.transparent,
          // elevation: null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              unlocked
                  ? Hero(
                      tag: "turtle-$id-$color",
                      child: SizedBox(
                        height: 93,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              "assets/images/turtles/swim/swim1.png",
                            ),
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
                                            TURTLE_COLORS[color]
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
                        ),
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
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          (TURTLE_COLORS_NAME[color] +
                              " " +
                              TURTLES[id].name.replaceAll(" Turtle", "")),
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(
                        height: 4,
                      ),
                      // Container(
                      //   height: 4,
                      //   width: 50,
                      //   decoration: BoxDecoration(
                      //       color: Colors.greenAccent,
                      //       borderRadius: BorderRadius.circular(5)),
                      // )
                      // Text("${quantity} found",
                      //     style: TextStyle(
                      //         fontSize: 14,
                      //         color: quantity > 0
                      //             ? Colors.tealAccent
                      //             : Colors.grey))
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
