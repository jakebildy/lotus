import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/shake_widget.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/debug_mode.dart';
import 'package:meditate_app/util/turtles.dart';

class EggCard extends StatelessWidget {
  final int index;

  EggCard({Key? key, required this.index}) : super(key: key);

  final shakeKey = GlobalKey<ShakeWidgetState>();

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();

    return GestureDetector(
      onTap: () {
        shakeKey.currentState?.shake();
        AudioPlayer egg = AudioPlayer();
        egg.setVolume(5.0);
        egg.play(AssetSource('audio/egg_crack.wav'));
        egg.dispose();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            key: UniqueKey(),
            backgroundColor: Colors.greenAccent,
            content: Text(
                index == 0
                    ? "Meditate ${(3 - user.user.value.hatchProgressEggOne).toString()} more day${(3 - user.user.value.hatchProgressEggOne) > 1 ? "s" : ""} to hatch this egg!"
                    : "Meditate 3 days to hatch this egg!",
                style: const TextStyle(fontWeight: FontWeight.bold))));

        //Log the event to AppsFlyer
        PostHogService appsflyer = Get.find();
        appsflyer.logEvent("EGG_TAPPED", {
          "more_days": (3 - user.user.value.hatchProgressEggOne).toString()
        });
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                          : user.user.value.hatchProgressEggOne == 2 &&
                                  index == 0
                              ? "assets/egg_crack_2.png"
                              : "assets/egg.png",
                      height: 60,
                    ),
                    (int.parse(user.user.value.eggTypes[index].split("-")[1]) ==
                            18)
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
                              height: 60,
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
                              height: 60,
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
                        : Container(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
