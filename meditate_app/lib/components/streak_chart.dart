import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/util.dart';

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
                bottomTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toInt().toString(),
                          style: const TextStyle(color: Colors.white));
                    },
                  ),
                ),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              minY: 0,
              maxY: getMaxValueForStreakChart(
                      userController.user.value.meditationHistory)
                  .toDouble(),
              lineBarsData: [
                LineChartBarData(
                  color: Colors.white, // Single color instead of list
                  isCurved: true,
                  barWidth: 5,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        // Colors.green.withOpacity(0.8),
                        // Colors.yellow.withOpacity(0.6),
                        // Colors.blue.withOpacity(0.4),
                        // Colors.purpleAccent.withOpacity(0.2),
                        Colors.green.withOpacity(0.2),
                        Colors.green.withOpacity(0.4),
                        Colors.green.withOpacity(0.6),
                        Colors.green.withOpacity(0.8),
                      ],
                    ),
                  ),
                  spots: List.generate(7, (index) {
                    DateTime date =
                        DateTime.now().subtract(Duration(days: 6 - index));
                    double value = (userController.user.value.meditationHistory[
                                DateTime.utc(
                                    date.year, date.month, date.day)] ??
                            0)
                        .toDouble();
                    return FlSpot(index + 1, value);
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
