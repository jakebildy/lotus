import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:meditate_app/components/egg_card.dart';
import 'package:meditate_app/components/turtle_card.dart';
import 'package:meditate_app/components/turtle_category.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/pages/new_egg_page.dart';
import 'package:meditate_app/pages/streak_count_page.dart';
import 'package:meditate_app/util/turtles.dart';

class TurtlesPage extends StatefulWidget {
  const TurtlesPage({Key? key}) : super(key: key);

  @override
  State<TurtlesPage> createState() => _TurtlesPageState();
}

class _TurtlesPageState extends State<TurtlesPage> {
  @override
  Widget build(BuildContext context) {
    SaveController saveController = Get.find();

    return Obx(() {
      int totalTurtles = 0;
      for (int i = 0; i < saveController.unlockedTurtles.length; i++) {
        if (i == 0) {
          totalTurtles = 0;
        }
        totalTurtles += int.parse(saveController.unlockedTurtleColors[i]
            .where((element) => element != -1)
            .toSet()
            .toList()
            .length
            .toString());
      }
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: TabBar(
              tabs: [
                Tab(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Turtles",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                          "${totalTurtles}/${TURTLES.length * TURTLE_COLORS.length}",
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Tab(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text("Eggs", style: TextStyle(fontSize: 18)),
                      Text(saveController.eggs.value.toString(),
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListView(children: [
                //Unlocked Turtles
                ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: List.generate(TURTLES.length, (index) {
                      return saveController.unlockedTurtles[index] == 0
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Container(
                                height: 100,
                                child: Center(
                                  child: TurtleCategory(
                                      unlocked: true,
                                      id: index,
                                      displayColor: saveController
                                              .unlockedTurtleColors[index]
                                              .contains(0)
                                          ? 0
                                          : saveController
                                              .unlockedTurtleColors[index]
                                              .where((element) => element != -1)
                                              .toList()[0],
                                      uniqueQuantity: saveController
                                          .unlockedTurtleColors[index]
                                          .where((element) => element != -1)
                                          .toSet()
                                          .toList()
                                          .length),
                                ),
                              ),
                            );
                    })),

                Divider(),

                //Locked Turtles
                ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: List.generate(TURTLES.length, (index) {
                      return saveController.unlockedTurtles[index] > 0
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Container(
                                height: 100,
                                child: Center(
                                  child: TurtleCategory(
                                    unlocked: false,
                                    id: index,
                                    uniqueQuantity: 0,
                                    displayColor: 0,
                                  ),
                                ),
                              ),
                            );
                    })),
              ]),
              saveController.eggs == 0
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "The longer you meditate, the higher your chance of finding an egg 🥚",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 8.0,
                      children:
                          List.generate(saveController.eggs.value, (index) {
                        return Center(
                          child: EggCard(
                            index: index,
                          ),
                        );
                      })),
            ],
          ),
        ),
      );
    });
  }
}
