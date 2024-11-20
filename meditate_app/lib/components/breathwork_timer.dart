import 'dart:math' as math;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/countdown_controller.dart';
import 'package:meditate_app/util/breathwork.dart';

class BreathworkTimer extends StatefulWidget {
  final int totalSeconds;
  final Breathwork breathwork;
  final bool paused;
  final bool vibrate;

  const BreathworkTimer({
    Key? key,
    this.totalSeconds = 20,
    this.vibrate = true,
    required this.paused,
    required this.breathwork,
  }) : super(key: key);

  @override
  State<BreathworkTimer> createState() => _BreathworkTimerState();
}

class _BreathworkTimerState extends State<BreathworkTimer> {
  @override
  void initState() {
    super.initState();
    breathwork();
  }

  bool isOnPage = true;
  double bubbleSize = 100;
  double opacity = 0.4;
  String title = "Get ready!"; //Get ready isn't actually shown to the user
  String count = "0";
  int breathIndex = 0;
  int stepIndex = 0;

  Future<void> breathwork() async {
    await Future.delayed(const Duration(seconds: 1));
    while (isOnPage) {
      if (isOnPage) {
        while (stepIndex < widget.breathwork.inOutTimes.length) {
          if (widget.vibrate) {
            HapticFeedback.lightImpact();
          }

          setState(() {
            if (widget.breathwork.instructions[stepIndex] == "Breathe in") {
              bubbleSize = 200;
              opacity = 1.0;
            } else if (widget.breathwork.instructions[stepIndex] ==
                "Breathe out") {
              bubbleSize = 100;
              opacity = 0.4;
            }

            title = widget.breathwork.instructions[stepIndex];
            count = "1";
            breathIndex = 0;
          });

          while (breathIndex < widget.breathwork.inOutTimes[stepIndex]) {
            await Future.delayed(const Duration(seconds: 1));
            while (widget.paused) {
              await Future.delayed(const Duration(seconds: 1));
            }
            setState(() {
              breathIndex++;
              count = (breathIndex + 1).toString();
            });
          }
          stepIndex++;
        }
      }
      stepIndex = 0;
    }
  }

  @override
  void dispose() {
    isOnPage = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CountdownController countdownController = Get.find();

    return Obx(
      () => Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 200,
            height: 200,
            // Use Stack to overlay ring and inner circle
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  // Use the properties stored in the State class.
                  width: bubbleSize,
                  height: bubbleSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedOpacity(
                          duration: Duration(
                              seconds: widget.breathwork.inOutTimes[stepIndex]),
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
                                      : const Color.fromARGB(255, 16, 77, 127)),
                          child: Text(
                            count,
                          )),
                      CustomPaint(
                        size: const Size(200, 200),
                        painter: RingPainter(
                            percentage:
                                (countdownController.totalSeconds.value -
                                        (countdownController
                                                .tenthsOfSecondsPassed.value /
                                            10)) /
                                    countdownController.totalSeconds.value),
                      ),
                    ],
                  ),
                  // Define how long the animation should take.
                  duration: Duration(
                      seconds: widget.breathwork.inOutTimes[stepIndex]),
                  // Provide an optional curve to make the animation feel smoother.
                  curve: Curves.fastOutSlowIn,
                ),
                // CustomPaint to draw the rings

                // Inner black circle with padding
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 184, // 200 - 8*2 for padding
                      height: 184, // 200 - 8*2 for padding
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                    ),
                    // Text(
                    //   '${(countdownController.totalSeconds.value - (countdownController.tenthsOfSecondsPassed.value ~/ 10)) ~/ 60}:${((countdownController.totalSeconds.value - (countdownController.tenthsOfSecondsPassed.value ~/ 10)) % 60).toString().padLeft(2, '0')}',
                    // ),
                    //This is to make sure the state updates correctly
                    Opacity(
                      opacity: 0,
                      child: Text(
                        countdownController.tenthsOfSecondsPassed.value
                            .toString(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          AnimatedTextKit(
            key: ValueKey(title), // Trigger animation on title change
            // just one at a time
            totalRepeatCount: 1,

            animatedTexts: [
              RotateAnimatedText(
                duration: Duration(
                    milliseconds: title == "Get ready!"
                        ? 200000
                        : widget.breathwork.inOutTimes[stepIndex] * 1000),
                title,
                textStyle: const TextStyle(fontSize: 20),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// CustomPainter to draw the rings
class RingPainter extends CustomPainter {
  final double percentage;
  RingPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final paintCovered = Paint()
      ..color = Colors.white38
      ..strokeWidth = 8 // Thickness of the ring
      ..style = PaintingStyle.stroke;

    final paintUncovered = Paint()
      ..color = Colors.black12
      ..strokeWidth = 8 // Same thickness for consistency
      ..style = PaintingStyle.stroke;

    // Angle for covered and uncovered parts
    final angleCovered = 2 * math.pi * percentage;
    final angleUncovered = 2 * math.pi * (1 - percentage);

    // Draw the covered arc (white)
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -math.pi / 2, // Starting from the top
      angleCovered,
      false,
      paintCovered,
    );

    // Draw the uncovered arc (black12)
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -math.pi / 2 + angleCovered, // Start where the covered arc ends
      angleUncovered,
      false,
      paintUncovered,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
