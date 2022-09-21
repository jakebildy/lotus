import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/streak_chart.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/pages/streak_count_page.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    SaveController saveController = Get.find();
    bool isDarkMode = true;

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          elevation: 0,
          title: Text("My Stats"),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "You've meditated for a total of",
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${saveController.totalMinutes} min",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 270,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black12 : Colors.white,
                    border: Border.all(
                      color: isDarkMode ? Colors.white24 : Colors.black26,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "This Week",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      StreakChart(
                        height: 200,
                      )
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 340,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black12 : Colors.white,
                  border: Border.all(
                    color: isDarkMode ? Colors.white24 : Colors.black26,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                          width: 60,
                          child: Image.asset(
                              saveController.streakIconURLBBright())),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (saveController.streakTier() == Tier.ORANGE
                                ? "Level 1: Hatchling"
                                : saveController.streakTier() == Tier.YELLOW
                                    ? "Level 2: Champion"
                                    : saveController.streakTier() == Tier.BLUE
                                        ? "Level 3: Expert"
                                        : "Level 4: Turtlemaster"),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: tierColor(saveController.streakTier())),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              width: 200,
                              child: Text(
                                  "Higher levels can find new turtles.\n\nReach new levels by increasing your average meditation length. Your level updates at the end of the week.\n")),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Hatchling: 0-20 Minutes/Day",
                            style: TextStyle(color: Colors.green),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Champion: 20-40 Minutes/Day",
                              style: TextStyle(color: Colors.yellow)),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Expert: 40-60 Minutes/Day",
                              style: TextStyle(color: Colors.lightBlueAccent)),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Turtlemaster: 60+ Minutes/Day",
                              style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
