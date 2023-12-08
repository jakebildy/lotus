import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/crescent_time.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:meditate_app/util/util.dart';

class MeditationHeatmap extends StatefulWidget {
  final double height;
  const MeditationHeatmap({Key? key, required this.height}) : super(key: key);

  @override
  State<MeditationHeatmap> createState() => _MeditationHeatmapState();
}

class _MeditationHeatmapState extends State<MeditationHeatmap> {
  @override
  Widget build(BuildContext context) {
    // SaveController saveController = Get.find();
    UserController userController = Get.find();
    logSuccess("!!! Meditation History " +
        userController.user.value.meditationHistory.toString());
    return Obx(
      () => ClipRRect(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          height: widget.height,
          child: HeatMap(
            scrollable: true,
            defaultColor: Colors.white12,
            colorMode: ColorMode.color,
            datasets: userController.user.value.meditationHistory.map(
                (key, value) =>
                    MapEntry(DateTime(key.year, key.month, key.day), value)),
            colorsets: const {
              // 5: Color.fromARGB(255, 173, 105, 2),
              // 10: Color.fromARGB(255, 219, 131, 0),
              5: Colors.green,
              // 10: Color.fromARGB(255, 255, 187, 0),
              10: Colors.yellow,
              20: Colors.blue,
              40: Colors.pinkAccent,
            },
            onClick: (value) {
              logInfo("Meditation history: " +
                  userController.user.value.meditationHistory.toString());
              setState(() {});
              if (userController.user.value.meditationHistory[value] != null) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "You meditated ${userController.user.value.meditationHistory[value]} minutes ${(formatDay(value) == "Today" ? "today" : "on " + formatDay(value)) + " " + Moon.emoji(value)}"),
                  duration: const Duration(seconds: 2),
                ));
              }
            },
          ),
        ),
      ),
    );
  }
}
