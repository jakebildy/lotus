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
                          daysShifted >= 7
                              ? 0.0
                              : user.meditationTimes[6 - daysShifted]
                                  .toDouble()),
                      FlSpot(
                          2,
                          daysShifted >= 6
                              ? 0.0
                              : user.meditationTimes[5 - daysShifted]
                                  .toDouble()),
                      FlSpot(
                          3,
                          daysShifted >= 5
                              ? 0.0
                              : user.meditationTimes[4 - daysShifted]
                                  .toDouble()),
                      FlSpot(
                          4,
                          daysShifted >= 4
                              ? 0.0
                              : user.meditationTimes[3 - daysShifted]
                                  .toDouble()),
                      FlSpot(
                          5,
                          daysShifted >= 3
                              ? 0.0
                              : user.meditationTimes[2 - daysShifted]
                                  .toDouble()),
                      FlSpot(
                          6,
                          daysShifted >= 2
                              ? 0.0
                              : user.meditationTimes[1 - daysShifted]
                                  .toDouble()),
                      FlSpot(
                          7,
                          daysShifted >= 1
                              ? 0.0
                              : user.meditationTimes[0 - daysShifted]
                                  .toDouble()),
                    ])
              ]),
        ),
      ),
    );
  }
}
