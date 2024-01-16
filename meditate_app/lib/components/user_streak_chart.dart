import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:meditate_app/models/user.dart';

class UserStreakChart extends StatelessWidget {
  final User user;
  final double height;
  const UserStreakChart({Key? key, required this.height, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    int daysShifted = user.meditationTimesAsOf.difference(date).inDays.abs();

    return ClipRRect(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: height,
        child: LineChart(
          LineChartData(
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: SideTitles(showTitles: false),
                leftTitles: SideTitles(showTitles: true),
                rightTitles: SideTitles(showTitles: false),
                topTitles: SideTitles(showTitles: false),
              ),
              minY: 0,
              maxY: 80,
              lineBarsData: [
                LineChartBarData(
                    colors: [
                      Colors.white,
                    ],
                    isCurved: true,
                    barWidth: 5,
                    belowBarData: BarAreaData(
                      show: true,
                      gradientFrom: const Offset(1, 1),
                      gradientTo: const Offset(1, 0),
                      gradientColorStops: [0.05, 0.15, 0.35, 1],
                      colors: [
                        // Color.fromARGB(0, 255, 153, 0),
                        Colors.green,
                        Colors.yellow,
                        Colors.blue,
                        Colors.purpleAccent
                      ],
                    ),
                    spots: [
                      FlSpot(
                          1,
                          (user.meditationHistory.map((key, value) => MapEntry(
                                      DateTime(key.year, key.month, key.day),
                                      value))[DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day)
                                      .subtract(const Duration(days: 6))] ??
                                  0)
                              .toDouble()),
                      FlSpot(
                          2,
                          (user.meditationHistory.map((key, value) => MapEntry(
                                      DateTime(key.year, key.month, key.day),
                                      value))[DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day)
                                      .subtract(const Duration(days: 5))] ??
                                  0)
                              .toDouble()),
                      FlSpot(
                          3,
                          (user.meditationHistory.map((key, value) => MapEntry(
                                      DateTime(key.year, key.month, key.day),
                                      value))[DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day)
                                      .subtract(const Duration(days: 4))] ??
                                  0)
                              .toDouble()),
                      FlSpot(
                          4,
                          (user.meditationHistory.map((key, value) => MapEntry(
                                      DateTime(key.year, key.month, key.day),
                                      value))[DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day)
                                      .subtract(const Duration(days: 3))] ??
                                  0)
                              .toDouble()),
                      FlSpot(
                          5,
                          (user.meditationHistory.map((key, value) => MapEntry(
                                      DateTime(key.year, key.month, key.day),
                                      value))[DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day)
                                      .subtract(const Duration(days: 2))] ??
                                  0)
                              .toDouble()),
                      FlSpot(
                          6,
                          (user.meditationHistory.map((key, value) => MapEntry(
                                      DateTime(key.year, key.month, key.day),
                                      value))[DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day)
                                      .subtract(const Duration(days: 1))] ??
                                  0)
                              .toDouble()),
                      FlSpot(
                          7,
                          (user.meditationHistory.map((key, value) =>
                                      MapEntry(
                                          DateTime(
                                              key.year, key.month, key.day),
                                          value))[DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day)] ??
                                  0)
                              .toDouble()),
                    ])
              ]),
        ),
      ),
    );
  }
}
