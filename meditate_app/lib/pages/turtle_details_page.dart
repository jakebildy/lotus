import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/controllers/game_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/flame/turtlegame.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';
import 'dart:math' as math;

import 'package:xl/xl.dart';

class TurtleDetailsPage extends StatefulWidget {
  final int id;
  final int color;
  const TurtleDetailsPage({Key? key, required this.id, required this.color})
      : super(key: key);

  @override
  State<TurtleDetailsPage> createState() => _TurtleDetailsPageState();
}

class _TurtleDetailsPageState extends State<TurtleDetailsPage>
    with SingleTickerProviderStateMixin {
  // Every 3 seconds, change a value swimState from 1 to 2
  int swimState = 1;
  Timer? _timer; // Declare a Timer
  late AnimationController _animationController;
  late Animation<double> _angleAnimation;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _scheduleRandomTimer();

    // Initialize the AnimationController
    _animationController = AnimationController(
      duration: const Duration(seconds: 3), // Duration of the smooth transition
      vsync: this,
    );

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

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed of
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GameController gameController = Get.find();
    UserController userController = Get.find();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Tap the turtle"),
      ),
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
        child: Stack(
          children: [
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
            ListView(
              // scrollable = false
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const SizedBox(
                  height: 40,
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      //color: Colors.white24,
                      height: 300,
                      child: GestureDetector(
                        onTap: () {
                          gameController.startGame(
                              widget.id, widget.color, context);
                          HapticFeedback.lightImpact();
                          Get.to(const TurtleGamePage(),
                              transition: Transition.circularReveal);
                        },
                        child: Hero(
                            tag: "turtle-${widget.id}",
                            child: XL(
                                sharesPointer: false,
                                // bypass the gesture detection to the parent

                                layers: [
                                  XLayer(
                                      xRotation: 0.4,
                                      yRotation: 0.4,
                                      xOffset: 110,
                                      yOffset: 110,
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
                                                          swimState.toString() +
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
                                                                    Colors.green
                                                                        .withOpacity(
                                                                            0.5),
                                                                    Colors.blue
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
                                                                  TURTLE_COLORS[
                                                                          widget
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
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          //Log the event to AppsFlyer
                          PostHogService posthog = Get.find();
                          posthog.logEvent("GAME_STARTED", {});
                          gameController.startGame(
                              widget.id, widget.color, context);
                          HapticFeedback.lightImpact();
                          Get.to(const TurtleGamePage(),
                              transition: Transition.circularReveal);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          //color: Colors.white24,
                          height: 300,
                          child: const Text(""),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                    color: const Color.fromARGB(96, 48, 48, 48),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            TURTLE_COLORS_NAME[widget.color] +
                                " " +
                                TURTLES[widget.id].name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: [
                                  Text(
                                    rarityReadable(TURTLES[widget.id].rarity),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: rarityColor(
                                            TURTLES[widget.id].rarity)),
                                  ),
                                  const Text(
                                    "Rarity",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "${userController.user.value.unlockedTurtles[widget.id]}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white),
                                  ),
                                  const Text(
                                    "Number Found",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: [
                                  const Text(
                                    "Level",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    TURTLES[widget.id].level.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: rarityColor(
                                            TURTLES[widget.id].rarity)),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${TURTLES[widget.id].name + "s"} are ${TURTLES[widget.id].rarity == Rarity.COMMON ? "commonly" : TURTLES[widget.id].rarity == Rarity.RARE ? "rarely" : "extremely rarely"} found in the Shallows. \n\nTheir eggs can be found by those at Level ${TURTLES[widget.id].level} or higher.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  width: 2.0, color: Colors.white),
                              backgroundColor: Colors.cyan,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              //Log the event to AppsFlyer
                              PostHogService posthog = Get.find();
                              posthog.logEvent("GAME_STARTED", {});
                              gameController.startGame(
                                  widget.id, widget.color, context);
                              HapticFeedback.lightImpact();
                              Get.to(const TurtleGamePage(),
                                  transition: Transition.circularReveal);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                "Go to Shallows",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            )),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 400,
                        )
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
