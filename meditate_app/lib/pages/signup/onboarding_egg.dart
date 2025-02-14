import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/egg_card.dart';
import 'package:meditate_app/components/shake_widget.dart';
import 'package:meditate_app/controllers/signup_controller.dart';
import 'package:meditate_app/effects/shatter/shatter_glass.dart';
import 'package:meditate_app/pages/login/login.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:meditate_app/util/turtles.dart';
import 'dart:math' as math;

import 'package:xl/xl.dart';

class OnboardingEgg extends StatefulWidget {
  const OnboardingEgg({super.key});

  @override
  State<OnboardingEgg> createState() => _OnboardingEggState();
}

class _OnboardingEggState extends State<OnboardingEgg>
    with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    SignupController controller = Get.find();
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width,
      ),
      Text(
        "Hatch your first egg!",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
      ),
      const SizedBox(height: 20),
      Stack(
        children: [
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
                          tag: "turtle-${0}",
                          child: XL(
                              sharesPointer: false,
                              // bypass the gesture detection to the parent

                              layers: [
                                XLayer(
                                    xRotation: hatched ? 0.4 : 0,
                                    yRotation: hatched ? 0.4 : 0,
                                    xOffset: 0,
                                    yOffset: 0,
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
                                                Center(
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/turtles/swim/swim${swimState}.png",
                                                        fit: BoxFit.contain,
                                                        width: 250,
                                                      ),
                                                      ColorFiltered(
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                                TURTLE_COLORS[0]
                                                                    .withOpacity(
                                                                        0.5),
                                                                BlendMode
                                                                    .srcATop),
                                                        child: Image.asset(
                                                          "assets/images/turtles/${0}.png",
                                                          fit: BoxFit.contain,
                                                          width: 250,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ));
                                        }))
                              ])),
                    )),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      hatched
                          ? "You found a Brown Swamp Turtle!"
                          : "Tap to hatch",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(!hatched ? "" : "What turtles will you find?",
                //       style: const TextStyle(fontSize: 14)),
                // ),
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () async {
                    if (!hatched) {
                      return;
                    }

                    controller.page.value = 1;
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: !hatched ? Colors.black26 : Colors.lightBlue,
                          border: Border.all(
                              color: !hatched ? Colors.white24 : Colors.white,
                              width: 2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 100),
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              color: !hatched ? Colors.white30 : Colors.white,
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
                        duration: Duration(seconds: 4),
                        key: ValueKey('ShatterGlass'),
                        child: Stack(
                          children: [
                            Image.asset(
                              "assets/egg_crack_2.png",
                              height: 250,
                              width: 250,
                            ),
                            ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                    TURTLE_COLORS[0].withOpacity(0.8),
                                    BlendMode.srcATop),
                                child: Image.asset(
                                  "assets/egg_spots.png",
                                  height: 250,
                                )),
                          ],
                        )),
                  ),
          )),
          // Spacer(),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 50),
          //   child: Hero(
          //     tag: "LoginButton",
          //     child: ElevatedButton(
          //         style: ButtonStyle(
          //             elevation: MaterialStateProperty.all<double>(0),
          //             backgroundColor:
          //                 MaterialStateProperty.all<Color>(Colors.lightBlue),
          //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //                 RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(10.0),
          //                     side:
          //                         BorderSide(color: Colors.white, width: 2)))),
          //         onPressed: () {
          //           PostHogService posthog = Get.find();
          //           posthog.logEvent("ONBOARDING_EGG_CONTINUE_PRESSED", {});
          //           controller.page.value = 1;
          //           controller.update();
          //         },
          //         child: SizedBox(
          //             width: 2000,
          //             child: Padding(
          //               padding: const EdgeInsets.all(12.0),
          //               child: Text("Continue",
          //                   textAlign: TextAlign.center,
          //                   style: TextStyle(
          //                       fontSize: 16,
          //                       color: Colors.white,
          //                       fontWeight: FontWeight.bold)),
          //             ))),
          //   ),
          // ),
          // const SizedBox(height: 10),
          // GestureDetector(
          //   onTap: () {
          //     controller.page.value = -3;
          //     controller.update();
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text(
          //       "Back",
          //       style:
          //           const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 60),
        ],
      )
    ]);
  }
}
