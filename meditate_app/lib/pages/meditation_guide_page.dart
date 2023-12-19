import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/pages/countdown_page.dart';

class MeditationGuide extends StatefulWidget {
  final Duration? time;
  const MeditationGuide({Key? key, required this.time}) : super(key: key);

  @override
  State<MeditationGuide> createState() => _MeditationGuideState();
}

class _MeditationGuideState extends State<MeditationGuide> {
  @override
  void initState() {
    super.initState();
    boxBreathing();
  }

  bool isOnPage = true;
  double size = 100;
  double opacity = 0.4;
  String title = "Breathe In";
  String count = "0";

  Future<void> boxBreathing() async {
    await Future.delayed(const Duration(seconds: 1));
    while (isOnPage) {
      if (isOnPage) {
        HapticFeedback.lightImpact();
        setState(() {
          size = 200;
          opacity = 1.0;
          title = "Breathe In";
          count = "1";
        });
      }
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        count = "2";
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        count = "3";
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        count = "4";
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        title = "Hold";
        count = "1";
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        count = "2";
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        count = "3";
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        count = "4";
      });
      await Future.delayed(const Duration(seconds: 1));
      if (isOnPage) {
        HapticFeedback.lightImpact();
        setState(() {
          size = 100;
          opacity = 0.4;
          title = "Breathe Out";
          count = "1";
        });
      }
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        count = "2";
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        count = "3";
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        count = "4";
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        count = "1";
        title = "Hold";
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        count = "2";
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        count = "3";
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        count = "4";
      });
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  void dispose() {
    isOnPage = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
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
          )),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                  child: FloatingBubbles.alwaysRepeating(
                noOfBubbles: 20,
                sizeFactor: 0.03,
                opacity: 40,
                paintingStyle: PaintingStyle.fill,
                strokeWidth: 1,
                shape: BubbleShape.circle,
                colorsOfBubbles: [
                  Colors.white.withAlpha(30),
                ],
              )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "If you haven't meditated before, try repeating the following breath exercise while you meditate:",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.time == null) {
                        Navigator.of(context).pop();
                      } else {
                        Get.off(CountdownPage(time: widget.time!),
                            transition: Transition.circularReveal,
                            duration: const Duration(seconds: 1));
                      }
                    },
                    child: Container(
                        color: const Color.fromARGB(255, 16, 77, 127),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 100),
                          child: Text(
                            "Continue",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 220),
                child: AnimatedDefaultTextStyle(
                    duration: const Duration(seconds: 1),
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: title == "Breathe In"
                            ? Colors.white
                            : title == "Hold"
                                ? Colors.lightGreen
                                : Colors.white),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 40, 30, 0),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 200 - size / 2),
                  child: AnimatedContainer(
                    // Use the properties stored in the State class.
                    width: size,
                    height: size,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedOpacity(
                            duration: const Duration(seconds: 5),
                            opacity: opacity,
                            child: Image.asset("assets/bubble.png")),
                        AnimatedDefaultTextStyle(
                            duration: const Duration(seconds: 1),
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: title == "Breathe In"
                                    ? const Color.fromARGB(255, 16, 77, 127)
                                    : title == "Hold"
                                        ? const Color.fromARGB(255, 42, 72, 7)
                                        : const Color.fromARGB(
                                            255, 16, 77, 127)),
                            child: Text(
                              count,
                            ))
                      ],
                    ),
                    // Define how long the animation should take.
                    duration: const Duration(seconds: 5),
                    // Provide an optional curve to make the animation feel smoother.
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
