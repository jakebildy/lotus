import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/premium_container.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/get_subscription_page.dart';
import 'package:meditate_app/util/ambiences.dart';

import '../app_pages.dart';

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
    UserController user = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Ambience"),
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

                  if (AMBIENCES[index].premium && user.user.value.isPremium) {
                    save.updateSelectedAmbience(AMBIENCES[index].name);
                    Get.offAll(const AppPages());
                  } else {
                    Get.to(const GetSubscriptionPage());
                  }
                },
                child: Card(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: (Column(
                    children: [
                      AspectRatio(
                          aspectRatio: 1.5,
                          child: Image.asset(
                            AMBIENCES[index].image,
                            fit: BoxFit.fitWidth,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                                child: Text(
                                  AMBIENCES[index].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: save.selectedAmbience.value ==
                                              AMBIENCES[index].name
                                          ? Colors.tealAccent
                                          : Colors.white),
                                ),
                              ),
                              AMBIENCES[index].premium
                                  ? const SizedBox(
                                      width: 80, child: PremiumContainer())
                                  : const SizedBox(
                                      width: 80,
                                      height: 30,
                                    )
                            ],
                          ),
                          AMBIENCES[index].name == "Random" ||
                                  AMBIENCES[index].name == "None"
                              ? Container(
                                  width: 30,
                                )
                              : IconButton(
                                  onPressed: () {
                                    // If currently playing this sound
                                    if (currentAudioSource == index) {
                                      // stop the audio

                                      audioPlayer.stop();
                                      setState(() {
                                        currentAudioSource = -1;
                                      });
                                    } else {
                                      // pause any audio already playing
                                      // TODO: debug
                                      audioPlayer.stop();

                                      // play the audio for 10 seconds
                                      audioPlayer.setVolume(5);
                                      audioPlayer.play(
                                        AssetSource(AMBIENCES[index]
                                            .audio
                                            .replaceAll("assets/", "")),
                                      );
                                      setState(() {
                                        currentAudioSource = index;
                                      });
                                    }
                                  },
                                  icon: Icon(currentAudioSource == index
                                      ? Icons.pause
                                      : Icons.play_arrow))
                        ],
                      ),
                    ],
                  )),
                )),
              ),
            );
          })),
    );
  }
}
