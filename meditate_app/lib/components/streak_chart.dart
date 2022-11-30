import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/save_controller.dart';

class StreakChart extends StatelessWidget {
  final double height;
  const StreakChart({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SaveController saveController = Get.find();

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
                        gradientFrom: Offset(1, 1),
                        gradientTo: Offset(1, 0),
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
                        FlSpot(1, saveController.lastSevenDays[6]),
                        FlSpot(2, saveController.lastSevenDays[5]),
                        FlSpot(3, saveController.lastSevenDays[4]),
                        FlSpot(4, saveController.lastSevenDays[3]),
                        FlSpot(5, saveController.lastSevenDays[2]),
                        FlSpot(6, saveController.lastSevenDays[1]),
                        FlSpot(7, saveController.lastSevenDays[0]),
                      ])
                ]),
          ),
        ),
      ),
    );
  }
}
