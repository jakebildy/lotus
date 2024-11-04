import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/user_controller.dart';

class StreakChart extends StatelessWidget {
  final double height;
  const StreakChart({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();

    return Obx(
      () => ClipRRect(
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
                          Colors.orange,
                          Colors.yellow,
                          Colors.blue,
                          Colors.purpleAccent
                        ],
                      ),
                      spots: [
                        FlSpot(
                            1,
                            (userController.user.value.meditationHistory.map(
                                        (key, value) =>
                                            MapEntry(
                                                DateTime.utc(key.year,
                                                    key.month, key.day),
                                                value))[DateTime.utc(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)
                                        .subtract(const Duration(days: 6))] ??
                                    0)
                                .toDouble()),
                        FlSpot(
                            2,
                            (userController.user.value.meditationHistory.map(
                                        (key, value) =>
                                            MapEntry(
                                                DateTime.utc(key.year,
                                                    key.month, key.day),
                                                value))[DateTime.utc(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)
                                        .subtract(const Duration(days: 5))] ??
                                    0)
                                .toDouble()),
                        FlSpot(
                            3,
                            (userController.user.value.meditationHistory.map(
                                        (key, value) =>
                                            MapEntry(
                                                DateTime.utc(key.year,
                                                    key.month, key.day),
                                                value))[DateTime.utc(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)
                                        .subtract(const Duration(days: 4))] ??
                                    0)
                                .toDouble()),
                        FlSpot(
                            4,
                            (userController.user.value.meditationHistory.map(
                                        (key, value) =>
                                            MapEntry(
                                                DateTime.utc(key.year,
                                                    key.month, key.day),
                                                value))[DateTime.utc(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)
                                        .subtract(const Duration(days: 3))] ??
                                    0)
                                .toDouble()),
                        FlSpot(
                            5,
                            (userController.user.value.meditationHistory.map(
                                        (key, value) =>
                                            MapEntry(
                                                DateTime.utc(key.year,
                                                    key.month, key.day),
                                                value))[DateTime.utc(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)
                                        .subtract(const Duration(days: 2))] ??
                                    0)
                                .toDouble()),
                        FlSpot(
                            6,
                            (userController.user.value.meditationHistory.map(
                                        (key, value) =>
                                            MapEntry(
                                                DateTime.utc(key.year,
                                                    key.month, key.day),
                                                value))[DateTime.utc(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)
                                        .subtract(const Duration(days: 1))] ??
                                    0)
                                .toDouble()),
                        FlSpot(
                            7,
                            (userController.user.value.meditationHistory.map(
                                        (key, value) => MapEntry(
                                            DateTime.utc(
                                                key.year, key.month, key.day),
                                            value))[DateTime.utc(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day)] ??
                                    0)
                                .toDouble()),
                      ])
                ]),
          ),
        ),
      ),
    );
  }
}
