import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/pages/streak_count_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final int STREAK_FREEZE_PRICE = 80;

  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = true;
    SaveController save = Get.find();

    return Obx(
      () => ListView(
        children: [
          GestureDetector(
            onTap: () {
              if (save.gems.value >= STREAK_FREEZE_PRICE) {
                if (save.streakFreezes < 2) {
                  print("Purchasing Streak Freeze!");
                  HapticFeedback.lightImpact();
                  save.updateGems(save.gems.value - STREAK_FREEZE_PRICE);
                  save.updateStreakFreezes(save.streakFreezes.value + 1);
                } else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.greenAccent,
                    key: UniqueKey(),
                    content: Text(
                        "You can only equip two Streak Freezes at a time!"),
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).clearSnackBars();
                Scaffold.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.greenAccent,
                  key: UniqueKey(),
                  content: Text("Earn more gems to purchase this!"),
                ));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150,
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
                          child: Image.asset("assets/streak_freeze.png")),
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
                            "Streak Freeze",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              width: 200,
                              child: Text(
                                  "Save your streak if you miss a day of meditation.")),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                  height: 20,
                                  child: Image.asset("assets/gem_icon.png")),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${STREAK_FREEZE_PRICE}",
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${save.streakFreezes}/2 ACTIVE",
                            style: TextStyle(
                                color: save.streakFreezes.value > 0
                                    ? Colors.greenAccent
                                    : Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
