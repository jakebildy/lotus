import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/premium_container.dart';
import 'package:meditate_app/controllers/network_status_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/get_subscription_page.dart';
import 'package:meditate_app/pages/select_ambience_page.dart';
import 'package:meditate_app/util/breathwork.dart';

import '../app_pages.dart';

class SelectBreathworkPage extends StatefulWidget {
  const SelectBreathworkPage({super.key});

  @override
  State<SelectBreathworkPage> createState() => _SelectBreathworkPageState();
}

class _SelectBreathworkPageState extends State<SelectBreathworkPage> {
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
    NetworkStatusController network = Get.find();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            onPressed: () {
              Get.offAll(const AppPages(), transition: Transition.topLevel);
            },
          ),
          title: Column(
            children: const [
              Text("Choose Breathwork"),
              Text(
                "Don't push yourself beyond your limits",
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
        body: GridView.count(
            crossAxisCount: 1,
            childAspectRatio: 1.3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 8.0,
            children: List.generate(BREATHWORKS.length, (index) {
              return Center(
                child: Bounce(
                  duration: const Duration(milliseconds: 110),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    UserController user = Get.find();

                    if (user.user.value.hasTriedBreathwork == false) {
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
                                        BREATHWORKS[index].name);
                                    Get.to(const SelectAmbiencePage(),
                                        transition: Transition.topLevel);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          color: Colors.lightBlue),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Text(
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
                    } else if (save.isSubscribedToPremium.value) {
                      save.updateBreathworkSelected(true);
                      save.updateSelectedBreathwork(BREATHWORKS[index].name);
                      Get.to(
                        const SelectAmbiencePage(),
                        transition: Transition.topLevel,
                      );
                    } else {
                      Get.to(const GetSubscriptionPage());
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Card(
                          elevation: 20,
                          color: Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              color: const Color.fromARGB(255, 84, 84, 84),
                              child: (Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AspectRatio(
                                          aspectRatio: 1.9,
                                          child:
                                              // gradient of blues
                                              Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.blue[900]!,
                                                      Colors.blue[800]!,
                                                      Colors.blue[700]!,
                                                      Colors.blue[600]!,
                                                      Colors.blue[500]!,
                                                      Colors.blue[400]!,
                                                      Colors.blue[300]!,
                                                      Colors.blue[200]!,
                                                      Colors.blue[100]!,
                                                      Colors.blue[50]!,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Opacity(
                                                opacity: 0.3,
                                                child: Image.asset(
                                                    "assets/breathwork_background.jpg",
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fit: BoxFit.cover),
                                              ),
                                            ],
                                          )),
                                      Column(
                                        children: [
                                          Text(BREATHWORKS[index].emoji,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 50)),
                                          Text(BREATHWORKS[index].whenToUse,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 20, 0, 4),
                                            child: Text(
                                              BREATHWORKS[index].name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: save.selectedAmbience
                                                              .value ==
                                                          BREATHWORKS[index]
                                                              .name
                                                      ? Colors.tealAccent
                                                      : Colors.white),
                                            ),
                                          ),
                                          Text(
                                            BREATHWORKS[index].description,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
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
