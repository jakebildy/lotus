import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/components/shake_widget.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/turtles.dart';

class NewEggPage extends StatefulWidget {
  const NewEggPage({Key? key}) : super(key: key);

  @override
  State<NewEggPage> createState() => _NewEggPageState();
}

class _NewEggPageState extends State<NewEggPage> with TickerProviderStateMixin {
  final shakeKey = GlobalKey<ShakeWidgetState>();

  @override
  void initState() {
    super.initState();
    shakeAfterASec();
  }

  bool isOnPage = true;

  Future<void> shakeAfterASec() async {
    await Future.delayed(const Duration(milliseconds: 400));
    shakeKey.currentState?.shake();
    HapticFeedback.lightImpact();

    while (isOnPage) {
      await Future.delayed(Duration(seconds: Random().nextInt(4) + 3));
      if (isOnPage) {
        shakeKey.currentState?.shake();
        HapticFeedback.lightImpact();
      }
    }
  }

  @override
  void dispose() {
    isOnPage = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 200,
                  child: ShakeWidget(
                      // 4. pass the GlobalKey as an argument
                      key: shakeKey,
                      // 5. configure the animation parameters
                      shakeCount: 3,
                      shakeOffset: 10,
                      shakeDuration: const Duration(milliseconds: 500),
                      child: GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            shakeKey.currentState?.shake();
                          },
                          child: Stack(
                            children: [
                              Image.asset("assets/egg.png"),
                              (int.parse(user.user.value.eggTypes.last
                                          .split("-")[1]) ==
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
                                        // height: 60,
                                      ),
                                    )
                                  : ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          TURTLE_COLORS[int.parse(user
                                                  .user.value.eggTypes.last
                                                  .split("-")[1])]
                                              .withOpacity(0.8),
                                          BlendMode.srcATop),
                                      child: Image.asset(
                                        "assets/egg_spots.png",
                                        // height: 60,
                                      )),
                            ],
                          )))),
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("You found an egg!",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Hatch it by meditating multiple days in a row.",
                    style: TextStyle(fontSize: 14)),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  // Leave a review at this stage:

                  Get.offAll(const AppPages());
                  SaveController save = Get.find();
                  if (save.hasReviewed.value == false) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            backgroundColor:
                                const Color.fromARGB(255, 47, 111, 129),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            title: const Text(
                              "Help Shellevate Grow",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    "Hey there! I’m one person designing, building and marketing this entire app. \n\nIf you like it, it would mean a lot if you could leave a review!",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        PostHogService posthog = Get.find();
                                        posthog
                                            .logEvent("REVIEW_SURE_TAPPED", {});
                                        final InAppReview inAppReview =
                                            InAppReview.instance;

                                        if (await inAppReview.isAvailable()) {
                                          inAppReview.requestReview();
                                          save.updateHasReviewed();
                                        }
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                            color: Colors.cyan,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: const Text("Sure ❤️",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          save.updateHasReviewed();
                                          PostHogService posthog = Get.find();
                                          posthog.logEvent(
                                              "REVIEW_NO_THANKS_TAPPED", {});
                                        },
                                        child: const Text("No Thanks"),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ));
                      },
                    );
                  }
                },
                child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 16, 77, 127),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12.0, horizontal: 100),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    )),
              )
            ],
          ),
        ));
  }
}
