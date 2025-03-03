import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:meditate_app/models/user.dart';

import '../util/util.dart';

class UserStreakChart extends StatelessWidget {
  final User user;
  final double height;
  const UserStreakChart({Key? key, required this.height, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            minY: 0,
            maxY: getMaxValueForStreakChart(user.meditationHistory).toDouble(),
            lineBarsData: [
              LineChartBarData(
                color: Colors.white, // Updated from `colors`
                isCurved: true,
                barWidth: 5,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
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
                  double value = (user.meditationHistory[
                              DateTime.utc(date.year, date.month, date.day)] ??
                          0)
                      .toDouble();
                  return FlSpot(index + 1, value);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
