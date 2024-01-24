import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/new_gems_page.dart';
import 'package:meditate_app/pages/turtle_hatch_page.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/save_controller.dart';

class StreakCountPage extends StatefulWidget {
  final int gemsAmount;
  final bool foundEgg;
  final bool alreadyMeditatedToday;
  final int turtleToHatch;
  final int turtleColorToHatch;

  const StreakCountPage(
      {Key? key,
      required this.gemsAmount,
      required this.foundEgg,
      required this.alreadyMeditatedToday,
      required this.turtleToHatch,
      required this.turtleColorToHatch})
      : super(key: key);

  @override
  State<StreakCountPage> createState() => _StreakCountPageState();
}

class _StreakCountPageState extends State<StreakCountPage>
    with TickerProviderStateMixin {
  int streakPlus = 0;
  double opacity = 0;
  @override
  void initState() {
    super.initState();

    increaseCount();
  }

  Future<void> increaseCount() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      if (!widget.alreadyMeditatedToday) {
        streakPlus += 1;
      }
      opacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();
    return Obx(() {
      int streak = widget.alreadyMeditatedToday
          ? userController.user.value.streak
          : userController.user.value.streak - 1 < 0
              ? 0
              : userController.user.value.streak - 1;
      return Scaffold(
          // backgroundColor: Colors.white,
          body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: opacity,
              child: SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  width: 409,
                  child: Image.asset("assets/fire_joypixel.gif")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text((streak + streakPlus).toString(),
                  style: const TextStyle(fontSize: 120, color: Colors.orange)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  userController.user.value.streak.toString() + " day streak!",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Meditate every day to build your streak",
                  style: TextStyle(fontSize: 14)),
            ),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () async {
                SaveController save = Get.find();
                if (save.requestNotifications.value == false) {
                  await Permission.notification.request();
                  save.updateRequestNotifications();
                }

                if (widget.turtleToHatch >= 0) {
                  Get.offAll(TurtleHatchPage(
                    gemsAmount: widget.gemsAmount,
                    foundEgg: widget.foundEgg,
                    turtleToHatch: widget.turtleToHatch,
                    turtleColorToHatch: widget.turtleColorToHatch,
                  ));
                } else {
                  Get.offAll(NewGemsPage(
                    gemsAmount: widget.gemsAmount,
                    foundEgg: widget.foundEgg,
                  ));
                }
              },
              child: Container(
                  color: const Color.fromARGB(255, 16, 77, 127),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 100),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  )),
            )
          ],
        ),
      ));
    });
  }
}
