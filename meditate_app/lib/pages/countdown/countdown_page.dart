import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/breathwork_timer.dart';
import 'package:meditate_app/components/countdown_timer.dart';
import 'package:meditate_app/controllers/countdown_controller.dart';
import 'package:meditate_app/controllers/egg_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/countdown/countdown_box_decoration.dart';
import 'package:meditate_app/pages/countdown/countdown_waves_and_art.dart';
import 'package:meditate_app/util/breathwork.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key, required this.time, required this.ambience})
      : super(key: key);

  final Duration time;
  final String ambience;

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with TickerProviderStateMixin {
  bool isPaused = false;
  bool isEnded = false;

  late AnimationController _playPauseController;

  /// The exact DateTime the meditation started
  late DateTime startTime;

  @override
  void initState() {
    _playPauseController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _playPauseController.forward();

    logInfo("⚡️ ENABLING WAKELOCK");
    WakelockPlus.enable();

    startTime = DateTime.now();
    CountdownController countdownController = Get.find();
    countdownController.startCountdownTimer();
    super.initState();
  }

  /// Dispose the controller
  @override
  void dispose() {
    _playPauseController.dispose();
    countdownController.disposeTimer();
    logInfo("⚡️ DISABLING WAKELOCK");
    WakelockPlus.disable();
    super.dispose();
  }

  //This function should execute when the app is reopened, and updates the timer accordingly. If the meditation is over, it will update the state and add the extra time.
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //restart the timer to the amount of seconds that have passed
      logInfo(
          "RESUMED! This might be where we should restart the timer to the amount of seconds that have passed.");

      // Check how many seconds have passed since lastTimerTime and update _start accordingly
      // int secondsPassed = DateTime.now().difference(lastTimerTime).inSeconds;
      // // setState(() {
      // //   _start += secondsPassed;
      // // });
    }
  }

  EggController eggController = Get.find();
  UserController userController = Get.find();
  CountdownController countdownController = Get.find();
  SaveController saveController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Scaffold(
            body: Container(
              decoration: getBoxDecorationForAmbience(widget.ambience),
              child: Stack(
                children: [
                  CountdownWavesAndArt(ambience: widget.ambience),
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height - 200,
                            ),
                            countdownController.meditationComplete.value
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0,
                                        120,
                                        0,
                                        MediaQuery.of(context).size.height *
                                            0.7),
                                    child: Column(
                                      children: [
                                        Text(
                                          saveController
                                                  .breathworkSelected.value
                                              ? "Breathwork Complete! \nReturn to breathing normally."
                                              : "Meditation Complete!",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 23,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "${countdownController.addExtraTime.value ? widget.time.inMinutes + countdownController.bonusTime.value ~/ 60 : widget.time.inMinutes} minute${(countdownController.addExtraTime.value ? widget.time.inMinutes + countdownController.bonusTime.value ~/ 60 : widget.time.inMinutes) > 1 ? "s" : ""}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 23,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0,
                                        0,
                                        0,
                                        MediaQuery.of(context).size.height < 720
                                            ? 340
                                            : MediaQuery.of(context)
                                                        .size
                                                        .height <
                                                    680
                                                ? 320
                                                : 360),
                                    child: Hero(
                                      tag: "TURTLE_TIMER",
                                      child: DefaultTextStyle(
                                          style: TextStyle(
                                            fontSize: widget.time >
                                                    const Duration(hours: 1)
                                                ? 30
                                                : 50.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2,
                                            child: saveController
                                                    .breathworkSelected.value
                                                ? BreathworkTimer(
                                                    paused: isPaused,
                                                    totalSeconds:
                                                        widget.time.inSeconds,
                                                    breathwork: BREATHWORKS
                                                        .where((element) =>
                                                            element.name ==
                                                            saveController
                                                                .selectedBreathwork
                                                                .value)
                                                        .first,
                                                  )
                                                : CountdownTimer(
                                                    totalSeconds:
                                                        widget.time.inSeconds,
                                                  ),
                                          )),
                                    ),
                                  ),
                            countdownController.meditationComplete.value
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 60),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (countdownController
                                            .addExtraTime.value) {
                                          countdownController.startBonusTimer();
                                        } else {
                                          countdownController.bonusTimer
                                              .cancel();
                                        }
                                        countdownController.addExtraTime.value =
                                            !countdownController
                                                .addExtraTime.value;
                                        countdownController.update();
                                      },
                                      child:
                                          countdownController.addExtraTime.value
                                              ? const Text(
                                                  "Added",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                )
                                              : Text(
                                                  "Add ${countdownController.bonusTime.value ~/ 60}:${countdownController.bonusTime.value % 60 < 10 ? "0" + (countdownController.bonusTime.value % 60).toString() : countdownController.bonusTime.value % 60}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                    ))
                                : Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0,
                                        0,
                                        0,
                                        MediaQuery.of(context).size.height < 680
                                            ? 130
                                            : 100),
                                    child: IconButton(
                                      iconSize: 50,
                                      onPressed: () {
                                        if (isEnded) {
                                          logInfo("Restarting countdown...");
                                          HapticFeedback.mediumImpact();
                                          _playPauseController.forward();
                                          // _controller.restart(
                                          //     duration: widget.time.inSeconds);
                                        } else if (isPaused) {
                                          logInfo("Resuming countdown...");
                                          // _controller.resume();
                                          countdownController
                                              .resumeCountdownTimer();

                                          HapticFeedback.mediumImpact();
                                          _playPauseController.forward();
                                          isPaused = false;
                                        } else {
                                          logInfo("Pausing countdown...");
                                          // _controller.pause();

                                          HapticFeedback.mediumImpact();
                                          _playPauseController.reverse();

                                          countdownController
                                              .pauseCountdownTimer();
                                          isPaused = true;
                                        }
                                        setState(() {});
                                      },
                                      // icon: Icon(isPaused || isEnded ? Icons.play_arrow :
                                      //             Icons.pause)
                                      icon: Hero(
                                        tag: "PLAY_BUTTON",
                                        child: AnimatedIcon(
                                          icon: AnimatedIcons.play_pause,
                                          progress: _playPauseController,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                              child: isPaused
                                  ? Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0,
                                          10,
                                          0,
                                          MediaQuery.of(context).size.height <
                                                  680
                                              ? 60
                                              : 20.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (countdownController
                                                      .tenthsOfSecondsPassed >=
                                                  600 &&
                                              countdownController
                                                      .loading.value !=
                                                  true) {
                                            // Set the total seconds to the amount of seconds passed
                                            countdownController.totalSeconds
                                                .value = (countdownController
                                                        .tenthsOfSecondsPassed
                                                        .value *
                                                    0.1)
                                                .round();
                                            countdownController.update();

                                            countdownController
                                                .submitMeditation();
                                          } else if (countdownController
                                                  .tenthsOfSecondsPassed <
                                              600) {
                                            Navigator.of(context).pop();
                                            countdownController.disposeTimer();
                                          }
                                        },
                                        child: Container(
                                            decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 16, 77, 127),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0,
                                                      horizontal: 100),
                                              child: countdownController
                                                          .tenthsOfSecondsPassed >
                                                      600
                                                  ? countdownController
                                                          .loading.value
                                                      ? const Text(
                                                          "Loading...",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20),
                                                        )
                                                      : const Text(
                                                          "Complete",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20),
                                                        )
                                                  : const Text(
                                                      "End Session",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                            )),
                                      ),
                                    )
                                  : countdownController.meditationComplete.value
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 80.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (countdownController
                                                      .loading.value !=
                                                  true) {
                                                countdownController
                                                    .submitMeditation();
                                              }
                                            },
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 16, 77, 127),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12.0,
                                                      horizontal: 100),
                                                  child: Text(
                                                    countdownController
                                                            .loading.value
                                                        ? "Loading..."
                                                        : "Continue",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                )),
                                          ),
                                        )
                                      : Container(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
