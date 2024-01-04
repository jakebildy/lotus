import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/egg_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/streak_count_page.dart';
import 'package:meditate_app/services/heap_service.dart';
import 'package:meditate_app/util/debug_mode.dart';
import 'package:meditate_app/util/eggquation.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:ocarina/ocarina.dart';
import 'package:wakelock/wakelock.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../models/user.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key, required this.time}) : super(key: key);

  final Duration time;

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with TickerProviderStateMixin {
  final CountDownController _controller = CountDownController();

  bool isPaused = false;
  bool isEnded = false;

  bool meditationComplete = false;
  bool addExtraTime = false;

  late AnimationController _playPauseController;

  late AudioPlayer bell;

  /// Whether the Continue button is loading after being pressed
  bool loading = false;

  /// The exact DateTime the meditation started
  late DateTime startTime;

  @override
  void initState() {
    _playPauseController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _playPauseController.forward();

    SaveController saveController = Get.find();

    bell = AudioPlayer();
    bell.setVolume(10.0);
    bell.play(AssetSource('audio/tibetan_chime.wav'));
    if (saveController.ambienceOn.value) {
      playAmbience();
    }

    logInfo("⚡️ ENABLING WAKELOCK");
    Wakelock.enable();

    startTime = DateTime.now();

    super.initState();
  }

  final player = OcarinaPlayer(
    asset: 'assets/audio/water_sounds.wav',
    loop: true,
    volume: 0.8,
  );

  Future<void> playAmbience() async {
    await player.load();
    await player.play();
  }

  /// Dispose the controller
  @override
  void dispose() {
    _playPauseController.dispose();
    player.dispose();
    _timer.cancel();
    bell.dispose();
    logInfo("⚡️ DISABLING WAKELOCK");
    Wakelock.disable();
    super.dispose();
  }

  // The timer that starts as soon as the meditation concludes
  late Timer _timer;
  int _start = 0;

  // Current DateTime
  DateTime lastTimerTime = DateTime.now();

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          _start++;
          lastTimerTime = DateTime.now();
        });
      },
    );
  }

  //This function should execute when the app is reopened, and updates the timer accordingly. If the meditation is over, it will update the state and add the extra time.
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //restart the timer to the amount of seconds that have passed
      logInfo(
          "RESUMED! This might be where we should restart the timer to the amount of seconds that have passed.");

      // Check how many seconds have passed since lastTimerTime and update _start accordingly
      int secondsPassed = DateTime.now().difference(lastTimerTime).inSeconds;
      setState(() {
        _start += secondsPassed;
      });
    }
  }

  EggController eggController = Get.find();
  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              // image: DecorationImage(
              //   fit: BoxFit.cover,
              //   image: AssetImage("assets/water_vibes.webp"),
              // ),
              ),
        ),
        Scaffold(
          // backgroundColor: isDarkMode ? Colors.black : Color(0xff87CEEB),
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff87CEEB),
                Color(0xff87CEEB),
                Color.fromARGB(255, 25, 178, 238),
                Color.fromARGB(255, 183, 163, 211),
                Color.fromARGB(255, 247, 190, 221),
                Color.fromARGB(255, 247, 244, 186),
                Color(0xff87CEEB),
                Color.fromARGB(255, 25, 178, 238),
              ],
            )),
            child: Stack(
              children: [
                // Padding(
                //       padding: EdgeInsets.fromLTRB(0,MediaQuery.of(context).size.height/2,0,0),
                //       child: Container(height: 500, color: Color(0xff8006994), width: MediaQuery.of(context).size.width,),
                //     ),
                WaveWidget(
                  config: CustomConfig(
                    colors: [
                      const Color.fromRGBO(0, 105, 147, 0.22),
                      const Color(0x3300BBF9),
                    ],
                    durations: [
                      10000,
                      12000,
                    ],
                    heightPercentages: [
                      0.54,
                      0.55,
                    ],
                  ),
                  backgroundColor: Colors.transparent,
                  size: const Size(double.infinity, double.infinity),
                  waveAmplitude: 0,
                ),

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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                            child: Image.asset("assets/lotus2.png"),
                          ),
                          meditationComplete
                              ? Padding(
                                  padding: EdgeInsets.fromLTRB(0, 120, 0,
                                      MediaQuery.of(context).size.height * 0.7),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Meditation Complete!",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "${addExtraTime ? widget.time.inMinutes + _start ~/ 60 : widget.time.inMinutes} minute${(addExtraTime ? widget.time.inMinutes + _start ~/ 60 : widget.time.inMinutes) > 1 ? "s" : ""}",
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
                                          : MediaQuery.of(context).size.height <
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
                                      child: CircularCountDownTimer(
                                        // Countdown duration in Seconds.
                                        duration: widget.time.inSeconds,
                                        initialDuration: 0,
                                        controller: _controller,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2,
                                        ringColor: Colors.black12,
                                        ringGradient: null,
                                        fillColor: Colors.white,
                                        fillGradient: null,
                                        backgroundColor: Colors.black38,
                                        backgroundGradient: null,
                                        strokeWidth: 10.0,
                                        strokeCap: StrokeCap.round,
                                        textStyle: TextStyle(
                                          fontSize: widget.time >
                                                  const Duration(hours: 1)
                                              ? 30
                                              : 50.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),

                                        // Format for the Countdown Text.
                                        textFormat: widget.time >
                                                const Duration(hours: 1)
                                            ? CountdownTextFormat.HH_MM_SS
                                            : CountdownTextFormat.MM_SS,
                                        isReverse: true,
                                        isReverseAnimation: true,
                                        isTimerTextShown: true,

                                        // Handles the timer start.
                                        autoStart: true,

                                        // This Callback will execute when the Countdown Starts.
                                        onStart: () {
                                          // Here, do whatever you want
                                          logInfo('Countdown Started');
                                          isEnded = false;
                                        },

                                        // This Callback will execute when the Countdown Ends.
                                        onComplete: () {
                                          // Here, do whatever you want
                                          isEnded = true;
                                          logInfo('Countdown Ended');
                                          player.dispose();
                                          bell.dispose();

                                          AudioPlayer endingBell =
                                              AudioPlayer();
                                          endingBell.setVolume(10.0);
                                          endingBell.play(AssetSource(
                                              'audio/tibetan_chime.wav'));
                                          startTimer();
                                          setState(() {
                                            meditationComplete = true;
                                          });
                                        },

                                        // This Callback will execute when the Countdown Changes.
                                        onChange: (String timeStamp) {
                                          // Here, do whatever you want
                                          // logInfo('Countdown Changed $timeStamp');
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                          meditationComplete
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 60),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (addExtraTime) {
                                        startTimer();
                                      } else {
                                        _timer.cancel();
                                      }
                                      setState(() {
                                        addExtraTime = !addExtraTime;
                                      });
                                    },
                                    child: addExtraTime
                                        ? const Text(
                                            "Added",
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          )
                                        : Text(
                                            "Add ${_start ~/ 60}:${_start % 60 < 10 ? "0" + (_start % 60).toString() : _start % 60}",
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
                                        _controller.restart(
                                            duration: widget.time.inSeconds);
                                      } else if (isPaused) {
                                        logInfo("Resuming countdown...");
                                        _controller.resume();
                                        player.resume();
                                        HapticFeedback.mediumImpact();
                                        _playPauseController.forward();
                                        isPaused = false;
                                      } else {
                                        logInfo("Pausing countdown...");
                                        _controller.pause();
                                        player.pause();
                                        HapticFeedback.mediumImpact();
                                        _playPauseController.reverse();
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
                                        MediaQuery.of(context).size.height < 680
                                            ? 60
                                            : 20.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                          color: const Color.fromARGB(
                                              255, 16, 77, 127),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        280,
                                                vertical: 10),
                                            child: const Text(
                                              "End Session",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          )),
                                    ),
                                  )
                                : meditationComplete
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 80.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (loading != true) {
                                              setState(() {
                                                loading = true;
                                              });

                                              int turtleToHatch = -1;
                                              int turtleColorToHatch = -1;

                                              int timeInMinutes =
                                                  widget.time.inMinutes;
                                              if (addExtraTime) {
                                                timeInMinutes += _start ~/ 60;
                                              }
                                              logInfo(
                                                  "Time in Minutes to add: $timeInMinutes");

                                              //Save the streak day
                                              DateTime now = DateTime.now();
                                              DateTime date = DateTime(
                                                  now.year, now.month, now.day);

                                              int gemsToGive = 0;
                                              bool alreadyMeditatedToday =
                                                  false;

                                              int numDays = userController
                                                  .user.value.lastMeditated
                                                  .difference(date)
                                                  .inDays
                                                  .abs();
                                              if (numDays == 1) {
                                                userController.updateStreak(
                                                    userController
                                                            .user.value.streak +
                                                        1);
                                                logInfo(
                                                    "Streak value is updated to ${userController.user.value.streak} + 1}.");
                                                userController.updateProperty(
                                                    UserProperty.gems,
                                                    userController
                                                            .user.value.gems +
                                                        5);
                                                gemsToGive += 5;
                                              } else if (numDays > 1) {
                                                userController.updateStreak(1);
                                                userController.updateProperty(
                                                    UserProperty.gems,
                                                    userController
                                                            .user.value.gems +
                                                        5);
                                                gemsToGive += 5;
                                                logInfo(
                                                    "Streak value is set to 1. NumDays was > 1.");
                                              } else {
                                                logInfo(
                                                    "You already meditated today. Not updating streak!");
                                                alreadyMeditatedToday = true;
                                              }

                                              userController.logMeditation(
                                                  timeInMinutes, date);

                                              userController.updateProperty(
                                                  UserProperty.gems,
                                                  userController
                                                          .user.value.gems +
                                                      timeInMinutes);
                                              gemsToGive += timeInMinutes;

                                              if (!alreadyMeditatedToday ||
                                                  DEBUG_MODE) {
                                                //Updating the egg progress if haven't already meditated today
                                                logInfo(
                                                    "First time meditating today");
                                                if (userController
                                                        .user.value.eggs >
                                                    0) {
                                                  if (userController.user.value
                                                          .hatchProgressEggOne >=
                                                      2) {
                                                    //Hatch a turtle!
                                                    userController
                                                        .updateProperty(
                                                            UserProperty.eggs,
                                                            userController
                                                                    .user
                                                                    .value
                                                                    .eggs -
                                                                1);

                                                    logInfo(
                                                        "HATCHING A TURTLE!");
                                                    turtleToHatch =
                                                        getTurtleToHatch();
                                                    turtleColorToHatch =
                                                        Random().nextInt(
                                                            TURTLE_COLORS
                                                                .length);

                                                    //if future turtles exist, this will be the one that displays on the
                                                    //hatching turtle page
                                                    if (userController
                                                        .user
                                                        .value
                                                        .eggTypes
                                                        .isNotEmpty) {
                                                      String eggTypeNew =
                                                          userController
                                                              .user
                                                              .value
                                                              .eggTypes[0];
                                                      turtleToHatch = int.parse(
                                                          eggTypeNew
                                                              .split("-")[0]);
                                                      turtleColorToHatch =
                                                          int.parse(eggTypeNew
                                                              .split("-")[1]);
                                                    }

                                                    eggController.hatchTurtle(
                                                        turtleToHatch,
                                                        turtleColorToHatch);
                                                    userController.updateProperty(
                                                        UserProperty
                                                            .hatchProgressEggOne,
                                                        0);
                                                  } else {
                                                    logInfo(
                                                        "Updating hatch process");

                                                    userController.updateProperty(
                                                        UserProperty
                                                            .hatchProgressEggOne,
                                                        userController
                                                                .user
                                                                .value
                                                                .hatchProgressEggOne +
                                                            1);
                                                  }
                                                }
                                              }

                                              //find an egg potentially
                                              bool foundEgg =
                                                  receiveEgg(timeInMinutes);
                                              if (foundEgg) {
                                                int tHatch = getTurtleToHatch();
                                                int tColor = Random().nextInt(
                                                    TURTLE_COLORS.length);

                                                eggController.addFutureTurtle(
                                                    tColor, tHatch);

                                                userController.updateProperty(
                                                    UserProperty.eggs,
                                                    userController
                                                            .user.value.eggs +
                                                        1);

                                                userController.updateProperty(
                                                    UserProperty.totalEggs,
                                                    userController.user.value
                                                            .totalEggs +
                                                        1);
                                              }

                                              //Log the event to AppsFlyer
                                              HeapService heap = Get.find();
                                              heap.logEvent(
                                                  "MEDITATION_COMPLETE", {
                                                "time": timeInMinutes.toString()
                                              });

                                              _timer.cancel();
                                              setState(() {
                                                loading = false;
                                              });
                                              Get.offAll(StreakCountPage(
                                                gemsAmount: gemsToGive,
                                                alreadyMeditatedToday:
                                                    alreadyMeditatedToday,
                                                foundEgg: foundEgg,
                                                turtleToHatch: turtleToHatch,
                                                turtleColorToHatch:
                                                    turtleColorToHatch,
                                              ));
                                            }
                                          },
                                          child: Container(
                                              color: const Color.fromARGB(
                                                  255, 16, 77, 127),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 100.0,
                                                        vertical: 10),
                                                child: Text(
                                                  loading
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
    );
  }
}
