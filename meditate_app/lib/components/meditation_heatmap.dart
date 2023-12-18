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
    UserController userController = Get.find();

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
              setState(() {});
              if (userController.user.value.meditationHistory.map(
                      (key, value) => MapEntry(
                          DateTime(key.year, key.month, key.day),
                          value))[value] !=
                  null) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.black,
                  content: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "You meditated ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              "${userController.user.value.meditationHistory.map((key, value) => MapEntry(DateTime(key.year, key.month, key.day), value))[value]} minutes ",
                          style: TextStyle(
                            color: userController.user.value.meditationHistory
                                        .map((key, value) => MapEntry(
                                            DateTime(
                                                key.year, key.month, key.day),
                                            value))[value]! >=
                                    40
                                ? Colors.pink
                                : userController.user.value.meditationHistory
                                            .map((key, value) => MapEntry(
                                                DateTime(key.year, key.month, key.day), value))[value]! >=
                                        20
                                    ? Colors.lightBlue
                                    : userController.user.value.meditationHistory.map((key, value) => MapEntry(DateTime(key.year, key.month, key.day), value))[value]! >= 10
                                        ? Colors.yellow
                                        : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              "${(formatDay(value) == "Today" ? "today" : "on " + formatDay(value)) + " " + Moon.emoji(value)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
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
