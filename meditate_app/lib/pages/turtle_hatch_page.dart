import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/effects/shatter/shatter_glass.dart';
import 'package:meditate_app/pages/new_gems_page.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:xl/xl.dart';
import 'dart:math' as math;

class TurtleHatchPage extends StatefulWidget {
  final int gemsAmount;
  final bool foundEgg;
  final bool levelUp;
  final int id;
  final int color;

  const TurtleHatchPage(
      {Key? key,
      required this.gemsAmount,
      required this.foundEgg,
      required this.levelUp,
      required this.id,
      required this.color})
      : super(key: key);

  @override
  State<TurtleHatchPage> createState() => _TurtleHatchPageState();
}

class _TurtleHatchPageState extends State<TurtleHatchPage>
    with TickerProviderStateMixin {
  double opacity = 0;

  final InAppReview inAppReview = InAppReview.instance;

  // Every 3 seconds, change a value swimState from 1 to 2
  int swimState = 1;
  Timer? _timer; // Declare a Timer
  late AnimationController _animationController;
  late Animation<double> _angleAnimation;
  late AnimationController _bounceAnimationController;
  final _random = math.Random();

  bool hatched = false;

  @override
  void initState() {
    super.initState();
    increaseCount();
    _scheduleRandomTimer();
    _animationController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    _bounceAnimationController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);

    // Initialize the angleAnimation
    _angleAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    // Randomly change the angle every few seconds smoothly
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        double newEnd = _random.nextDouble() * 20 -
            10; // Generate a random target between -10 and 10
        _angleAnimation = Tween<double>(
          begin: _angleAnimation.value, // Start from the current value
          end: newEnd,
        ).animate(CurvedAnimation(
            parent: _animationController, curve: Curves.linear));

        _animationController
          ..reset() // Reset the controller
          ..forward(); // Start the animation towards the new value
      }
    });
  }

  Future<void> increaseCount() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      opacity = 1;
    });
  }

  void _scheduleRandomTimer() {
    // Cancel the existing timer if it exists
    _timer?.cancel();

    // Schedule a new timer with a random interval
    _timer = Timer(Duration(milliseconds: _random.nextInt(2500) + 500), () {
      setState(() {
        // Toggle swimState between 1 and 2
        swimState = swimState == 1 ? 2 : 1;
      });

      // Schedule the next timer with a new random interval
      _scheduleRandomTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed of
    _animationController.dispose();
    super.dispose();
  }

  bool hatching = false;
  void hatchEgg() async {
    if (hatching) {
      return;
    }
    hatching = true;

    logSuccess("Hatching!");
    AudioPlayer egg = AudioPlayer();
    egg.setVolume(1.0);
    egg.play(AssetSource('audio/egg_crack.wav'));
    await Future.delayed(const Duration(seconds: 1));
    egg.play(AssetSource('audio/egg_pop.mp3'));
    await Future.delayed(const Duration(milliseconds: 1500));
    _bounceAnimationController.repeat(reverse: true);
    setState(() {
      hatched = true;
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    _bounceAnimationController.dispose();
  }

  SaveController save = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff87CEEB),
                Color.fromARGB(255, 100, 162, 200),
                Color.fromARGB(255, 25, 142, 238),
                Color.fromARGB(255, 1, 62, 137),
              ],
            )),
            child: Stack(children: [
              // black color
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.5),
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
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        height: 300,
                        width: 409,
                        child: ScaleTransition(
                          scale: Tween(begin: 0.75, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: _bounceAnimationController,
                                  curve: Curves.elasticOut)),
                          child: Hero(
                              tag: "turtle-${widget.id}",
                              child: XL(
                                  sharesPointer: false,
                                  // bypass the gesture detection to the parent

                                  layers: [
                                    XLayer(
                                        xRotation: hatched ? 0.4 : 0,
                                        yRotation: hatched ? 0.4 : 0,
                                        xOffset: hatched ? 110 : 0,
                                        yOffset: hatched ? 110 : 0,
                                        child: AnimatedBuilder(
                                            animation: _angleAnimation,
                                            builder: (context, child) {
                                              return (Transform.rotate(
                                                angle: _angleAnimation.value *
                                                    math.pi /
                                                    180,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/images/turtles/swim/swim" +
                                                            swimState
                                                                .toString() +
                                                            ".png"),
                                                    widget.id != 21
                                                        ? Container()
                                                        : Image.asset(
                                                            "assets/images/turtles/21_underlay.png"),
                                                    widget.id >= 0 &&
                                                            widget.id <
                                                                TURTLES.length
                                                        ? (widget.color == 18
                                                            ? ShaderMask(
                                                                shaderCallback:
                                                                    (Rect
                                                                        bounds) {
                                                                  return LinearGradient(
                                                                    colors: [
                                                                      Colors.red
                                                                          .withOpacity(
                                                                              0.5),
                                                                      Colors.red
                                                                          .withOpacity(
                                                                              0.5),
                                                                      Colors
                                                                          .orange
                                                                          .withOpacity(
                                                                              0.5),
                                                                      Colors
                                                                          .yellow
                                                                          .withOpacity(
                                                                              0.5),
                                                                      Colors
                                                                          .green
                                                                          .withOpacity(
                                                                              0.5),
                                                                      Colors
                                                                          .blue
                                                                          .withOpacity(
                                                                              0.5),
                                                                      Colors
                                                                          .indigo
                                                                          .withOpacity(
                                                                              0.5),
                                                                      Colors
                                                                          .purple
                                                                          .withOpacity(
                                                                              0.5),
                                                                      Colors
                                                                          .purple
                                                                          .withOpacity(
                                                                              0.5),
                                                                    ],
                                                                    begin: Alignment
                                                                        .centerLeft,
                                                                    end: Alignment
                                                                        .centerRight,
                                                                  ).createShader(
                                                                      bounds);
                                                                },
                                                                blendMode:
                                                                    BlendMode
                                                                        .srcATop,
                                                                child: Image.asset(
                                                                    "assets/images/turtles/${widget.id}.png"),
                                                              )
                                                            : ColorFiltered(
                                                                colorFilter: ColorFilter.mode(
                                                                    TURTLE_COLORS[widget
                                                                            .color]
                                                                        .withOpacity(
                                                                            0.5),
                                                                    BlendMode
                                                                        .srcATop),
                                                                child: Image.asset(
                                                                    "assets/images/turtles/${widget.id}.png"),
                                                              ))
                                                        : Container(),
                                                    widget.id != 10
                                                        ? Container()
                                                        : Image.asset(
                                                            "assets/images/turtles/10_overlay.png"),
                                                    widget.id != 23
                                                        ? Container()
                                                        : Image.asset(
                                                            "assets/images/turtles/23_overlay.png"),
                                                  ],
                                                ),
                                              ));
                                            }))
                                  ])),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          hatched
                              ? "Your egg hatched!"
                              : "Tap to hatch your egg",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          !hatched
                              ? ""
                              : "You found a ${TURTLE_COLORS_NAME[widget.color]} ${TURTLES[widget.id].name}.",
                          style: const TextStyle(fontSize: 14)),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (!hatched) {
                          return;
                        }

                        if (widget.gemsAmount == -1) {
                          Get.offAll(const AppPages());
                        } else {
                          Get.offAll(NewGemsPage(
                            gemsAmount: widget.gemsAmount,
                            foundEgg: widget.foundEgg,
                            levelUp: widget.levelUp,
                          ));
                        }

                        SaveController save = Get.find();
                        if (save.hasReviewed.value == false) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  backgroundColor:
                                      const Color.fromARGB(255, 47, 111, 129),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  title: Column(
                                    children: const [
                                      Text(
                                        "Enjoying Shellevate?",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text("⭐️⭐️⭐️⭐️⭐️",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center),
                                    ],
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                          "Your review helps spread the word - it's just one person building this app!",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              PostHogService posthog =
                                                  Get.find();
                                              posthog.logEvent(
                                                  "REVIEW_SURE_TAPPED", {});
                                              final InAppReview inAppReview =
                                                  InAppReview.instance;

                                              if (await inAppReview
                                                  .isAvailable()) {
                                                inAppReview.requestReview();
                                                save.updateHasReviewed();
                                              }
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2),
                                                  color: Colors.cyan,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text("Rate app",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                save.updateHasReviewed();
                                                PostHogService posthog =
                                                    Get.find();
                                                posthog.logEvent(
                                                    "REVIEW_NO_THANKS_TAPPED",
                                                    {});
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
                          decoration: BoxDecoration(
                              color:
                                  !hatched ? Colors.black26 : Colors.lightBlue,
                              border: Border.all(
                                  color:
                                      !hatched ? Colors.white24 : Colors.white,
                                  width: 2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 100),
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                  color:
                                      !hatched ? Colors.white30 : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          )),
                    )
                  ],
                ),
              ),

              Center(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 180),
                child: hatched
                    ? Container()
                    : Listener(
                        onPointerUp: (event) => hatchEgg(),
                        behavior: HitTestBehavior.translucent,
                        child: ShatterGlass(
                            duration: const Duration(seconds: 4),
                            key: const ValueKey('ShatterGlass'),
                            child: Stack(
                              children: [
                                Image.asset(
                                  "assets/egg_crack_2.png",
                                  height: 250,
                                  width: 250,
                                ),
                                (widget.color == 18)
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
                                          height: 250,
                                        ),
                                      )
                                    : ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            TURTLE_COLORS[widget.color]
                                                .withOpacity(0.8),
                                            BlendMode.srcATop),
                                        child: Image.asset(
                                          "assets/egg_spots.png",
                                          height: 250,
                                        )),
                              ],
                            )),
                      ),
              )),
            ])));
  }
}
