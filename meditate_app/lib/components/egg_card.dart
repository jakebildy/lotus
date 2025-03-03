import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/shake_widget.dart';
import 'package:meditate_app/controllers/subscription_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/debug_mode.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:shimmer/shimmer.dart';

class EggCard extends StatelessWidget {
  final int index;
  EggCard({Key? key, required this.index}) : super(key: key);
  final shakeKey = GlobalKey<ShakeWidgetState>();

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();

    return Stack(
      children: [
        Card(
          // color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: EggWidget(
              index: index,
              size: 60,
              shakeKey: null,
            ),
          ),
        ),
        GestureDetector(
          //  make it so that gesture detectors that are children are not able to be tapped
          behavior: HitTestBehavior.opaque,

          onTap: () {
            // open a dialog if the egg is not ready to hatch, saying how many days are left

            SubscriptionController subscriptionController = Get.find();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Obx(
                    () => AlertDialog(
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(
                          index == 0
                              ? "Meditate ${(3 - user.user.value.hatchProgressEggOne).toString()} more day${(3 - user.user.value.hatchProgressEggOne) > 1 ? "s" : ""} to hatch this egg!"
                              : "Meditate 3 days to hatch this egg!",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      EggWidget(
                        index: index,
                        size: 120,
                        shakeKey: shakeKey,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          PostHogService posthog = Get.find();
                          posthog.logEvent("BUY_HATCH_EGG_TAPPED", {});

                          subscriptionController.purchaseInstantEggHatch();
                        },
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.green, // Lighter shade of purple
                                    Colors.teal, // Darker shade of purple
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.circular(20), // Rounded corner
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: 0,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                          subscriptionController
                                                      .purchasingEggHatch
                                                      .value ==
                                                  true
                                              ? "Loading..."
                                              : "Hatch instantly for \$0.99",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                                opacity: 0.8,
                                child: Shimmer.fromColors(
                                    baseColor: Colors.white10,
                                    highlightColor: Colors.white30,
                                    child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 5),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                    subscriptionController
                                                                .purchasingEggHatch
                                                                .value ==
                                                            true
                                                        ? "Loading..."
                                                        : "Hatch instantly for \$0.99",
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              20), // Rounded corner
                                          border: Border.all(
                                            color: Colors.transparent,
                                            width: 0,
                                          ),
                                        )))),
                          ],
                        ),
                      ),
                    ])),
                  );
                });

            // ScaffoldMessenger.of(context).clearSnackBars();
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     key: UniqueKey(),
            //     backgroundColor: Colors.greenAccent,
            //     content: Text(
            //         index == 0
            //             ? "Meditate ${(3 - user.user.value.hatchProgressEggOne).toString()} more day${(3 - user.user.value.hatchProgressEggOne) > 1 ? "s" : ""} to hatch this egg!"
            //             : "Meditate 3 days to hatch this egg!",
            //         style: const TextStyle(fontWeight: FontWeight.bold))));

            //Log the event to Posthog
            PostHogService posthog = Get.find();
            posthog.logEvent("EGG_TAPPED", {
              "more_days": (3 - user.user.value.hatchProgressEggOne).toString()
            });
          },
          child: Container(
            width: 100,
            height: 100,
          ),
        ),
      ],
    );
  }
}

class EggWidget extends StatelessWidget {
  final int index;
  final double size;
  GlobalKey<ShakeWidgetState>? shakeKey = GlobalKey<ShakeWidgetState>();

  EggWidget(
      {super.key,
      required this.size,
      required this.index,
      required this.shakeKey});

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();
    return GestureDetector(
      onTap: () {
        if (shakeKey != null) {
          shakeKey!.currentState?.shake();
          AudioPlayer egg = AudioPlayer();
          egg.setVolume(1.0);
          egg.play(AssetSource('audio/egg_crack.wav'));
          egg.dispose();
        }
      },
      child: Column(
        children: [
          ShakeWidget(
              // 4. pass the GlobalKey as an argument
              key: shakeKey,
              // 5. configure the animation parameters
              shakeCount: 3,
              shakeOffset: 10,
              shakeDuration: const Duration(milliseconds: 500),
              // 6. Add the child widget that will be animated
              child: Stack(children: [
                Image.asset(
                  user.user.value.hatchProgressEggOne == 1 && index == 0
                      ? "assets/egg_crack_1.png"
                      : user.user.value.hatchProgressEggOne == 2 && index == 0
                          ? "assets/egg_crack_2.png"
                          : "assets/egg.png",
                  height: size,
                ),
                (int.parse(user.user.value.eggTypes[index].split("-")[1]) == 18)
                    ? ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [
                              Colors.red.withOpacity(0.5),
                              Colors.orange.withOpacity(0.5),
                              Colors.yellow.withOpacity(0.5),
                              Colors.green.withOpacity(0.5),
                              Colors.blue.withOpacity(0.5),
                              Colors.indigo.withOpacity(0.5),
                              Colors.purple.withOpacity(0.5),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.centerRight,
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcATop,
                        child: Image.asset(
                          "assets/egg_spots.png",
                          height: size,
                        ),
                      )
                    : ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            TURTLE_COLORS[int.parse(user
                                    .user.value.eggTypes[index]
                                    .split("-")[1])]
                                .withOpacity(0.8),
                            BlendMode.srcATop),
                        child: Image.asset(
                          "assets/egg_spots.png",
                          height: size,
                        )),
                DEBUG_MODE == true
                    ? Text(
                        user.user.value.eggTypes[index],
                        style: const TextStyle(color: Colors.black),
                      )
                    : const Text("")
              ])),
          const SizedBox(
            height: 10,
          ),
          Obx(
            () => Stack(
              // alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.black26,
                  width: MediaQuery.of(context).size.width / 3 - 10,
                  height: 4,
                ),
                user.user.value.hatchProgressEggOne != 0 && index == 0
                    ? Container(
                        color: Colors.greenAccent,
                        width: user.user.value.hatchProgressEggOne == 0
                            ? 0
                            : user.user.value.hatchProgressEggOne == 1
                                ? 30
                                : 60,
                        height: 4,
                      )
                    : Container(
                        width: 0,
                        height: 4,
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
