import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/try_for_free_container.dart';
import 'package:meditate_app/controllers/network_status_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/get_subscription/get_subscription_page.dart';
import 'package:meditate_app/util/ambiences.dart';
import 'package:meditate_app/util/util.dart';

class SelectAmbiencePage extends StatefulWidget {
  const SelectAmbiencePage({super.key});

  @override
  State<SelectAmbiencePage> createState() => _SelectAmbiencePageState();
}

class _SelectAmbiencePageState extends State<SelectAmbiencePage> {
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
    UserController user = Get.find();

    return Obx(
      () => Scaffold(
        // backgroundColor: const Color.fromARGB(255, 47, 111, 129),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            backgroundColor: Colors.transparent,
            // backgroundColor: const Color.fromARGB(255, 47, 111, 129),
            elevation: 0,
            // leading: IconButton(
            //   icon: const Icon(Icons.keyboard_arrow_down),
            //   onPressed: () {
            //     Get.offAll(const AppPages(), transition: Transition.topLevel);
            //   },
            // ),
            title: Column(
              children: const [
                // Text("Choose Soundscape"),
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
        ),
        body: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 8.0,
            children: List.generate(AMBIENCES.length, (index) {
              return Center(
                child: Bounce(
                  duration: const Duration(milliseconds: 110),
                  onPressed: () {
                    HapticFeedback.mediumImpact();

                    if (!AMBIENCES[index].premium ||
                        save.isSubscribedToPremium.value ||
                        user.user.value.isPremiumOverride == true ||
                        user.user.value.createdAt
                            .isBefore(PREMIUM_BEFORE_DATE)) {
                      save.updateSelectedAmbience(AMBIENCES[index].name);
                      // Get.offAll(const AppPages(),
                      //     transition: Transition.topLevel);
                    } else {
                      if (network.offline.value) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            key: UniqueKey(),
                            backgroundColor: Colors.black,
                            content: const Text(
                              "Go online to unlock premium content!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )));
                      } else {
                        Get.to(const GetSubscriptionPage());
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Card(
                        color: Colors.transparent,
                        // color: Color.fromARGB(255, 7, 7, 7),
                        elevation:
                            save.selectedAmbience.value == AMBIENCES[index].name
                                ? 0
                                : 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 138, 138, 138),
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(
                                    color: save.selectedAmbience.value ==
                                            AMBIENCES[index].name
                                        ? Colors.tealAccent
                                        : Colors.transparent,
                                    width: 2)),
                            child: (Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                AspectRatio(
                                    aspectRatio: 1,
                                    child: AMBIENCES[index].name == "No Sound"
                                        ? const Icon(
                                            Icons.music_off,
                                            size: 60,
                                            color: Colors.white54,
                                          )
                                        : Image.asset(
                                            AMBIENCES[index].image,
                                            fit: BoxFit.cover,
                                          )),
                                Container(
                                  color: Colors.black54,
                                  height: 60,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 4),
                                            child: Text(
                                              AMBIENCES[index].name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: save.selectedAmbience
                                                              .value ==
                                                          AMBIENCES[index].name
                                                      ? Colors.tealAccent
                                                      : Colors.white),
                                            ),
                                          ),
                                          AMBIENCES[index].premium
                                              ? const SizedBox(
                                                  width: 80,
                                                  child: TryForFreeContainer())
                                              : const SizedBox(
                                                  width: 80,
                                                  height: 30,
                                                )
                                        ],
                                      ),
                                      AMBIENCES[index].name == "Random" ||
                                              AMBIENCES[index].name ==
                                                  "No Sound"
                                          ? Container(
                                              width: 30,
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                // If currently playing this sound
                                                if (currentAudioSource ==
                                                    index) {
                                                  // stop the audio

                                                  audioPlayer.stop();
                                                  setState(() {
                                                    currentAudioSource = -1;
                                                  });
                                                } else {
                                                  audioPlayer.stop();

                                                  // play the audio for 10 seconds
                                                  audioPlayer.setVolume(5);

                                                  if (AMBIENCES[index]
                                                      .audio
                                                      .startsWith("https")) {
                                                    audioPlayer.play(UrlSource(
                                                        AMBIENCES[index]
                                                            .audio));
                                                  } else {
                                                    audioPlayer.play(
                                                      AssetSource(
                                                          AMBIENCES[index]
                                                              .audio
                                                              .replaceAll(
                                                                  "assets/",
                                                                  "")),
                                                    );
                                                  }
                                                  setState(() {
                                                    currentAudioSource = index;
                                                  });
                                                }
                                              },
                                              icon: Icon(
                                                  currentAudioSource == index
                                                      ? Icons.pause
                                                      : Icons.play_arrow))
                                    ],
                                  ),
                                ),
                              ],
                            )),
                          ),
                        )),
                  ),
                ),
              );
            })),
      ),
    );
  }
}
