import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/new_gems_page.dart';
import 'package:meditate_app/pages/turtle_hatch_page.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';
import 'package:stroke_text/stroke_text.dart';
import '../controllers/save_controller.dart';
import 'package:path_provider/path_provider.dart';

class StreakCountPage extends StatefulWidget {
  final int gemsAmount;
  final bool foundEgg;
  final bool levelUp;
  final bool alreadyMeditatedToday;
  final int turtleToHatch;
  final int turtleColorToHatch;

  const StreakCountPage(
      {Key? key,
      required this.gemsAmount,
      required this.foundEgg,
      required this.levelUp,
      required this.alreadyMeditatedToday,
      required this.turtleToHatch,
      required this.turtleColorToHatch})
      : super(key: key);

  @override
  State<StreakCountPage> createState() => _StreakCountPageState();
}

class _StreakCountPageState extends State<StreakCountPage>
    with TickerProviderStateMixin {
  int streakPlus = 0;
  double opacity = 0;

  bool sharingToStory = false;

  @override
  void initState() {
    super.initState();

    increaseCount();
  }

  ScreenshotController screenshotController = ScreenshotController();

  Future<void> increaseCount() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      if (!widget.alreadyMeditatedToday) {
        streakPlus += 1;
      }
      opacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();
    return Obx(() {
      int streak = widget.alreadyMeditatedToday
          ? userController.user.value.streak
          : userController.user.value.streak - 1 < 0
              ? 0
              : userController.user.value.streak - 1;
      return Screenshot(
          controller: screenshotController,
          child: Scaffold(
              backgroundColor: Colors.grey[900],
              body: Stack(
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      //  padding: const EdgeInsets.fromLTRB(20,20,20,38),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(
                              "assets/ocean_background.jpeg",
                              fit: BoxFit.fill,
                            )),
                      ),
                    ),
                  ),
                  Hero(
                    tag: "WaterAnimation",
                    child: Opacity(
                      opacity: 0.3,
                      child: Image.asset(
                        "assets/images/game/water_2.gif",
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                      child: FloatingBubbles.alwaysRepeating(
                    noOfBubbles: 20,
                    colorsOfBubbles: [
                      Colors.white.withAlpha(30),
                    ],
                    sizeFactor: 0.03,
                    opacity: 70,
                    paintingStyle: PaintingStyle.fill,
                    strokeWidth: 1,
                    shape: BubbleShape
                        .circle, // circle is the default. No need to explicitly mention if its a circle.
                  )),
                  Container(
                    color: Colors.black54,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 120),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 800),
                                opacity: opacity,
                                child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    width: 180,
                                    child: Image.asset("assets/fire.gif")),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8.0),
                              child: StrokeText(
                                  text: (streak + streakPlus).toString(),
                                  strokeColor: Colors.white,
                                  strokeWidth: 5,
                                  textStyle: const TextStyle(
                                      fontSize: 120,
                                      fontWeight: FontWeight.bold,
                                      // color gradient from orange to white

                                      color: Colors.orange)),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("day streak ",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "You've meditated " +
                                  userController.user.value.streak.toString() +
                                  " days.\n Keep it up!",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  height: 1.6)),
                        ),
                        // const Padding(
                        //   padding: EdgeInsets.all(8.0),
                        //   child: Text("Meditate every day to build your streak",
                        //       style: TextStyle(fontSize: 14)),
                        // ),
                        const SizedBox(
                          height: 50,
                        ),

                        sharingToStory
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset("assets/app_icon.jpg",
                                        height: 40),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "shellevate",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      SaveController save = Get.find();
                                      if (save.requestNotifications.value ==
                                          false) {
                                        await Permission.notification.request();
                                        save.updateRequestNotifications();
                                      }

                                      if (widget.turtleToHatch >= 0) {
                                        Get.offAll(TurtleHatchPage(
                                          gemsAmount: widget.gemsAmount,
                                          foundEgg: widget.foundEgg,
                                          id: widget.turtleToHatch,
                                          color: widget.turtleColorToHatch,
                                          levelUp: widget.levelUp,
                                        ));
                                      } else {
                                        Get.offAll(NewGemsPage(
                                          gemsAmount: widget.gemsAmount,
                                          foundEgg: widget.foundEgg,
                                          levelUp: widget.levelUp,
                                        ));
                                      }
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.lightBlue,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 100),
                                          child: Text(
                                            "Continue",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  userController.user.value.streak % 10 != 0
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              sharingToStory = true;
                                            });

                                            HapticFeedback.mediumImpact();

                                            // wait for the new image to load
                                            await Future.delayed(const Duration(
                                                milliseconds: 500));

                                            try {
                                              //Log the event to PostHog
                                              PostHogService posthog =
                                                  Get.find();
                                              posthog.logEvent(
                                                  "SHARE_TO_STORY_TAPPED", {});

                                              // Capture the screenshot
                                              final image =
                                                  await screenshotController
                                                      .capture();

                                              if (image != null) {
                                                // Get a temporary directory to save the image
                                                final directory =
                                                    await getTemporaryDirectory();
                                                final imagePath =
                                                    "${directory.path}/screenshot.png";

                                                // Save the image to a file
                                                final file = File(imagePath);
                                                await file.writeAsBytes(image);

                                                // Share the image on Instagram Story
                                                await SocialShare
                                                    .shareInstagramStory(
                                                  appId: "587093930383035",
                                                  imagePath: imagePath,
                                                  attributionURL:
                                                      "https://shellevate.app/get",
                                                );
                                              } else {
                                                logInfo(
                                                    "Screenshot capture failed.");
                                              }
                                            } catch (e) {
                                              logInfo("Error: $e");
                                            }

                                            setState(() {
                                              sharingToStory = false;
                                            });
                                          },
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 22.0,
                                                        horizontal: 100),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.asset(
                                                        "assets/instagram.png",
                                                        height: 22),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      "Share to my story",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ],
              )));
    });
  }
}
