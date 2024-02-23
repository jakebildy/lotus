import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/controllers/countdown_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/pages/countdown_page.dart';
import 'package:meditate_app/pages/meditation_guide_page.dart';
import 'package:meditate_app/pages/select_ambience_page.dart';
import 'package:meditate_app/services/heap_service.dart';

import '../components/duration_picker.dart';
import '../util/ambiences.dart';
import '../util/debug_mode.dart';

class BeginMeditationPage extends StatefulWidget {
  const BeginMeditationPage({Key? key}) : super(key: key);

  @override
  State<BeginMeditationPage> createState() => _BeginMeditationPageState();
}

class _BeginMeditationPageState extends State<BeginMeditationPage> {
  Duration noTime = const Duration(hours: 0, minutes: 0);
  late Duration _duration = const Duration(hours: 0, minutes: 5);

  @override
  void initState() {
    super.initState();
    SaveController saveController = Get.find();
    setState(() {
      _duration = Duration(
          hours: 0, minutes: saveController.defaultMeditationTime.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    SaveController saveController = Get.find();

    return Obx(
      () => Scaffold(
        backgroundColor: const Color.fromARGB(255, 47, 111, 129),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 33, 135, 175),
                Color.fromARGB(255, 65, 113, 142),
                Color.fromARGB(255, 21, 115, 155),
                Color.fromARGB(255, 1, 126, 137),
              ],
            ))),
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
            Opacity(
              opacity: 0.3,
              child: Image.asset(
                "assets/images/game/water_2.gif",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
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
            Padding(
              padding: const EdgeInsets.all(0),
              //  padding: const EdgeInsets.fromLTRB(20,20,20,38),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "assets/ocean_foreground.png",
                      fit: BoxFit.fill,
                    )),
              ),
            ),
            Center(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //The Turtle Timer 🐢
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.3 + 40,
                    child: FittedBox(
                      child: Hero(
                        tag: "TURTLE_TIMER",
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 38),
                              child: SizedBox(
                                  height: 360,
                                  child:
                                      Image.asset("assets/turtle_timer.png")),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: SizedBox(
                                height: 400,
                                width: 240,
                                child: DurationPicker(
                                  duration: _duration,
                                  baseUnit: BaseUnit.minute,
                                  onChange: (val) {
                                    if (_duration != val) {
                                      HapticFeedback.lightImpact();
                                    }
                                    setState(() => _duration = val);
                                  },
                                  snapToMins: 5.0,
                                ),
                              ),
                            ),
                            IgnorePointer(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(3, 10, 0, 0),
                                child: Opacity(
                                  opacity: 0.15,
                                  child: SizedBox(
                                      height: 190,
                                      width: 190,
                                      child: Image.asset(
                                        "assets/turtle_lines.png",
                                        fit: BoxFit.fill,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (() {
                      Get.to(const SelectAmbiencePage(),
                          transition: Transition.downToUp);
                    }),
                    child: Column(
                      children: [
                        MediaQuery.of(context).size.height < 680
                            ? Container()
                            : const SizedBox(
                                height: 30,
                              ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white54,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  saveController.selectedAmbience.value != "OFF"
                                      ? Icons.music_note
                                      : Icons.music_off,
                                  size: 30,
                                ),
                                Text(
                                  "Soundscape: " +
                                      saveController.selectedAmbience.value,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(Icons.arrow_drop_down, color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: _duration == noTime ||
                                  _duration <
                                      (DEBUG_MODE == true
                                          ? const Duration(minutes: 1)
                                          : const Duration(minutes: 5))
                              ? const SizedBox(
                                  height: 50,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30.0),
                                    child: Text(
                                      "Meditate for at least five minutes to build a habit!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                              : GestureDetector(
                                  onTap: (() {
                                    HapticFeedback.heavyImpact();

                                    //Log the event to AppsFlyer
                                    HeapService heap = Get.find();
                                    heap.logEvent("MEDITATION_TAPPED", {
                                      "time": _duration.inMinutes.toString()
                                    });

                                    CountdownController countdownController =
                                        Get.find();
                                    countdownController.totalSeconds.value =
                                        _duration.inSeconds;
                                    countdownController.update();

                                    if (_duration.inMinutes >= 5) {
                                      saveController
                                          .updateDefaultMeditationTime(
                                              _duration.inMinutes);
                                    }

                                    if (saveController
                                            .getValue("GUIDE_SHOWN") ==
                                        "TRUE") {
                                      if (saveController
                                              .selectedAmbience.value ==
                                          "Random") {
                                        saveController.updateSelectedAmbience(
                                            AMBIENCES[Random()
                                                    .nextInt(AMBIENCES.length)]
                                                .name);
                                      }
                                      Get.to(
                                          CountdownPage(
                                              time: _duration,
                                              ambience: saveController
                                                  .selectedAmbience.value),
                                          transition: Transition.circularReveal,
                                          duration: const Duration(seconds: 1));
                                    } else {
                                      Get.to(
                                          MeditationGuide(
                                              time: _duration,
                                              ambience: saveController
                                                  .selectedAmbience.value),
                                          transition: Transition.circularReveal,
                                          duration: const Duration(seconds: 1));
                                      saveController.saveValue(
                                          "GUIDE_SHOWN", "TRUE");
                                    }
                                  }),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        // border: Border.all(
                                        //     color: Colors.cyan),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        color: Colors.cyan,
                                        borderRadius:
                                            BorderRadius.circular(60)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Hero(
                                          tag: "PLAY_BUTTON",
                                          child: Icon(
                                            Icons.play_arrow,
                                            size: 50,
                                            color: Colors.white,
                                          )),
                                    ),
                                  )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
