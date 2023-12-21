import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/streak_chart.dart';
import 'package:meditate_app/controllers/user_controller.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          elevation: 0,
          title: const Text("My Stats"),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "You've meditated for a total of",
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${userController.totalMinutes()} min",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    border: Border.all(
                      color: Colors.white24,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        userController.streakAverage().toStringAsFixed(1) +
                            " min",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Weekly Average",
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 270,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    border: Border.all(
                      color: Colors.white24,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: const [
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
          ],
        ),
      ),
    );
  }
}
