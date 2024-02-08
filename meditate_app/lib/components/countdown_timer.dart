import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/countdown_controller.dart';

class CountdownTimer extends StatefulWidget {
  final int totalSeconds;

  const CountdownTimer({Key? key, this.totalSeconds = 20}) : super(key: key);

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  @override
  Widget build(BuildContext context) {
    CountdownController countdownController = Get.find();

    return Obx(
      () => SizedBox(
        width: 200,
        height: 200,
        // Use Stack to overlay ring and inner circle
        child: Stack(
          alignment: Alignment.center,
          children: [
            // CustomPaint to draw the rings
            CustomPaint(
              size: Size(200, 200),
              painter: RingPainter(
                  percentage: (countdownController.totalSeconds.value -
                          (countdownController.tenthsOfSecondsPassed.value /
                              10)) /
                      countdownController.totalSeconds.value),
            ),
            // Inner black circle with padding
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 184, // 200 - 8*2 for padding
                  height: 184, // 200 - 8*2 for padding
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black38,
                  ),
                ),
                Text(
                  '${(countdownController.totalSeconds.value - (countdownController.tenthsOfSecondsPassed.value ~/ 10)) ~/ 60}:${((countdownController.totalSeconds.value - (countdownController.tenthsOfSecondsPassed.value ~/ 10)) % 60).toString().padLeft(2, '0')}',
                ),
                //This is to make sure the state updates correctly
                Opacity(
                  opacity: 0,
                  child: Text(
                    countdownController.tenthsOfSecondsPassed.value.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
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
      ..color = Colors.white
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
