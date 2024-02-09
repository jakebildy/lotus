import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/countdown_timer.dart';
import 'package:meditate_app/controllers/countdown_controller.dart';
import 'package:meditate_app/controllers/egg_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/ambiences.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:wakelock/wakelock.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../components/bubbles/bubbles.dart';

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
    Wakelock.enable();

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
    Wakelock.disable();
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

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
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
              decoration: AMBIENCES
                          .where((element) => element.name == widget.ambience)
                          .first
                          .setting ==
                      "Rain"
                  ? const BoxDecoration(
                      gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 205, 205, 205),
                        Color(0xff87CEEB),
                        Color.fromARGB(255, 25, 178, 238),
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromRGBO(255, 255, 255, 1),
                        Color.fromARGB(255, 255, 255, 255),
                        Color(0xff87CEEB),
                        Color.fromARGB(255, 25, 178, 238),
                      ],
                    ))
                  : AMBIENCES
                              .where(
                                  (element) => element.name == widget.ambience)
                              .first
                              .setting ==
                          "Night"
                      ? const BoxDecoration(
                          gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black,
                            Colors.black,
                            Color.fromARGB(255, 183, 163, 211),
                          ],
                        ))
                      : const BoxDecoration(
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

                  AMBIENCES
                              .where(
                                  (element) => element.name == widget.ambience)
                              .first
                              .setting ==
                          "Night"
                      ? Opacity(
                          opacity: 0.2,
                          child: Image.asset(
                            "assets/stars.jpg",
                            height: 500,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(),

                  AMBIENCES
                              .where(
                                  (element) => element.name == widget.ambience)
                              .first
                              .setting ==
                          "Jungle"
                      ? Image.asset(
                          "assets/jungle_top.png",
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      : Container(),

                  Center(
                    child: Stack(alignment: Alignment.bottomCenter, children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                        child: Image.asset("assets/lotus2.png"),
                      ),
                    ]),
                  ),
                  AMBIENCES
                              .where(
                                  (element) => element.name == widget.ambience)
                              .first
                              .setting ==
                          "Rain"
                      ? Opacity(
                          opacity: 0.5,
                          child: Image.asset(
                            "assets/images/rainy_overlay.gif",
                            height: 1000,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(),

                  AMBIENCES
                              .where(
                                  (element) => element.name == widget.ambience)
                              .first
                              .setting ==
                          "Underwater"
                      ? Stack(
                          children: [
                            Image.asset(
                              "assets/ocean_background.jpeg",
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
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
                          ],
                        )
                      : Container(),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AMBIENCES
                                      .where((element) =>
                                          element.name == widget.ambience)
                                      .first
                                      .setting ==
                                  "Jungle" ||
                              AMBIENCES
                                      .where((element) =>
                                          element.name == widget.ambience)
                                      .first
                                      .setting ==
                                  "Forest"
                          ? Image.asset(
                              "assets/jungle_bottom.png",
                              height: 230,
                              fit: BoxFit.cover,
                            )
                          : Container(),
                    ],
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
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                            //   child: Image.asset("assets/lotus2.png"),
                            // ),
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
                                            child: CountdownTimer(
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
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                            decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 16, 77, 127),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12.0,
                                                  horizontal: 100),
                                              child: Text(
                                                "End Session",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
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
