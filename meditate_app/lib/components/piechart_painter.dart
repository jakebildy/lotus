import 'dart:math';
import 'package:flutter/material.dart';

class PieChartPainter extends CustomPainter {
  double percentage;
  Color fillColor;
  Color backgroundColor;

  PieChartPainter(
      {required this.percentage,
      required this.fillColor,
      required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    // Draw background circle
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);

    // Draw filled arc for the percentage
    paint.color = fillColor;
    double sweepAngle = 2 * pi * (percentage / 100);
    canvas.drawArc(
        Rect.fromCircle(
            center: size.center(Offset.zero), radius: size.width / 2),
        -pi / 2,
        sweepAngle,
        false,
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
