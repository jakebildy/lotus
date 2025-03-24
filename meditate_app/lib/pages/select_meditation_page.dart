import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/components/premium_container.dart';
import 'package:meditate_app/controllers/network_status_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/countdown/countdown_page.dart';
import 'package:meditate_app/pages/get_subscription/get_subscription_page.dart';
import 'package:meditate_app/pages/shop_page.dart';
import 'package:meditate_app/util/breathwork.dart';
import 'package:meditate_app/util/util.dart';

class SelectMeditationPage extends StatefulWidget {
  final Duration time;
  final String ambience;

  const SelectMeditationPage(
      {super.key, required this.time, required this.ambience});

  @override
  State<SelectMeditationPage> createState() => _SelectMeditationPageState();
}

class _SelectMeditationPageState extends State<SelectMeditationPage> {
  int currentAudioSource = -1;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SaveController save = Get.find();
    UserController user = Get.find();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          elevation: 0,
          forceMaterialTransparency: true,
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            onPressed: () {
              Get.offAll(const AppPages(), transition: Transition.topLevel);
            },
          ),
          title: Column(
            children: const [
              Text("Choose Meditation",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Text(
                "Don't push yourself beyond your limits.",
                style: TextStyle(fontSize: 12, color: Colors.white38),
              ),

              // network.offline.value
              //     ? const Text(
              //         "Premium ambiences are not available offline",
              //         style:
              //             TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              //       )
              //     : Container(),
            ],
          ),
        ),

        // extendBody: true,
        // bottomNavigationBar: SafeArea(
        //   child: Container(
        //     color: Colors.black87,
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Text(
        //         " If you feel uncomfortable or lightheaded, stop and breathe normally.",
        //         style: TextStyle(fontSize: 12, color: Colors.white38),
        //         textAlign: TextAlign.center,
        //       ),
        //     ),
        //   ),
        // ),
        // extendBodyBehindAppBar: true,
        body: GridView.count(
            crossAxisCount: 1,
            // padding between the items should be 0
            padding: const EdgeInsets.all(8.0),
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 0,
            childAspectRatio: 1.15,
            children: List.generate(BREATHWORKS.length + 1, (index) {
              if (index == 0) {
                return Column(
                  children: [
                    Center(
                      child: Bounce(
                        duration: const Duration(milliseconds: 110),
                        onPressed: () {
                          HapticFeedback.mediumImpact();

                          SaveController save = Get.find();
                          save.updateBreathworkSelected(false);

                          Get.to(
                              CountdownPage(
                                  time: widget.time, ambience: widget.ambience),
                              transition: Transition.circularReveal,
                              duration: const Duration(seconds: 1));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 276,
                            child: Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color:
                                        const Color.fromARGB(255, 84, 84, 84),
                                    child: (Column(
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 264,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  color: Colors.black,
                                                ),
                                                Opacity(
                                                  opacity: 0.5,
                                                  child: Stack(
                                                    children: [
                                                      ColorFiltered(
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                            Colors.blue.withOpacity(
                                                                0.5), // Adjust the opacity as needed
                                                            BlendMode
                                                                .color, // Choose a blend mode that suits your design
                                                          ),
                                                          child: Image.asset(
                                                            "assets/breathwork_background.jpg",
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 264,
                                                            fit: BoxFit.fill,
                                                          )),
                                                      BackdropFilter(
                                                        filter:
                                                            ImageFilter.blur(
                                                          sigmaX:
                                                              20.0, // Adjust the X blur intensity
                                                          sigmaY:
                                                              20.0, // Adjust the Y blur intensity
                                                        ),
                                                        child: Container(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0), // Transparent container to apply blur
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                const Text(
                                                    "Freestyle Meditation",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20)),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: const [
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                  ),
                                )),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: save.breathworkSelected.value == false
                                      ? Colors.transparent
                                      : Colors.transparent,
                                  width: 2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const DividerWithText(text: "BREATHWORK"),
                  ],
                );
              }

              return Center(
                child: Bounce(
                  duration: const Duration(milliseconds: 110),
                  onPressed: () {
                    HapticFeedback.mediumImpact();

                    UserController user = Get.find();

                    if (user.user.value.hasTriedBreathwork == false &&
                        !save.isSubscribedToPremium.value &&
                        !user.user.value.isPremiumOverride == true &&
                        !user.user.value.createdAt
                            .isBefore(PREMIUM_BEFORE_DATE)) {
                      // show a dialog saying this is paid, but you can try it this time for free!
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Try Breathwork"),
                              content: const Text(
                                  "Breathwork is part of Shellevate Premium. You can try it for free this time!"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    save.updateBreathworkSelected(true);
                                    save.updateSelectedBreathwork(
                                        BREATHWORKS[index - 1].name);
                                    Get.back();

                                    Get.to(
                                        CountdownPage(
                                            time: widget.time,
                                            ambience: widget.ambience),
                                        transition: Transition.circularReveal,
                                        duration: const Duration(seconds: 1));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          color: Colors.lightBlue),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Okay",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text("Cancel"),
                                ),
                              ],
                            );
                          });
                    } else if (save.isSubscribedToPremium.value ||
                        user.user.value.isPremiumOverride == true ||
                        user.user.value.createdAt
                            .isBefore(PREMIUM_BEFORE_DATE)) {
                      save.updateBreathworkSelected(true);
                      save.updateSelectedBreathwork(
                          BREATHWORKS[index - 1].name);
                      Get.to(
                          CountdownPage(
                              time: widget.time, ambience: widget.ambience),
                          transition: Transition.circularReveal,
                          duration: const Duration(seconds: 1));
                    } else {
                      Get.to(const GetSubscriptionPage());
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 276,
                      child: Card(
                          elevation: 0,
                          color: Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: const Color.fromARGB(255, 84, 84, 84),
                              child: (Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height: 264,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.black,
                                          ),
                                          Opacity(
                                            opacity: 0.5,
                                            child: Stack(
                                              children: [
                                                ColorFiltered(
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      BREATHWORKS[index - 1]
                                                          .color
                                                          .withOpacity(
                                                              0.5), // Adjust the opacity as needed
                                                      BlendMode
                                                          .color, // Choose a blend mode that suits your design
                                                    ),
                                                    child: Image.asset(
                                                      "assets/breathwork_background.jpg",
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 264,
                                                      fit: BoxFit.fill,
                                                    )),
                                                BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                    sigmaX:
                                                        20.0, // Adjust the X blur intensity
                                                    sigmaY:
                                                        20.0, // Adjust the Y blur intensity
                                                  ),
                                                  child: Container(
                                                    color: Colors.black.withOpacity(
                                                        0), // Transparent container to apply blur
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(BREATHWORKS[index - 1].emoji,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 50)),
                                          Text(BREATHWORKS[index - 1].whenToUse,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 26)),
                                          BREATHWORKS[index - 1].advanced ==
                                                  true
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.orange,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                        border: Border.all(
                                                            color:
                                                                Colors.orange,
                                                            width: 2)),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(4.0),
                                                      child: Text("Difficult",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: 12)),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 20, 0, 4),
                                                child: Text(
                                                  BREATHWORKS[index - 1].name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color:
                                                          save.selectedAmbience
                                                                      .value ==
                                                                  BREATHWORKS[
                                                                          index -
                                                                              1]
                                                                      .name
                                                              ? Colors
                                                                  .transparent
                                                              : Colors.white70),
                                                ),
                                              ),
                                              Text(
                                                BREATHWORKS[index - 1]
                                                    .description,
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              save.isSubscribedToPremium
                                                          .value ||
                                                      user.user.value
                                                          .isPremiumOverride ||
                                                      user.user.value.createdAt
                                                          .isBefore(
                                                              PREMIUM_BEFORE_DATE)
                                                  ? Container()
                                                  : Container(
                                                      width: 80,
                                                      child:
                                                          PremiumContainer()),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                            ),
                          )),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: save.selectedBreathwork.value ==
                                        BREATHWORKS[index - 1].name &&
                                    save.breathworkSelected.value == true
                                ? Colors.transparent
                                : Colors.transparent,
                            width: 2),
                      ),
                    ),
                  ),
                ),
              );
            })),
      ),
    );
  }
}
