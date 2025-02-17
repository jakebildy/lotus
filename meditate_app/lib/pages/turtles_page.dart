import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/egg_card.dart';
import 'package:meditate_app/components/turtle_card_new.dart';
import 'package:meditate_app/components/turtle_category.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/trophies/trophies_page.dart';
import 'package:meditate_app/util/turtles.dart';

class TurtlesPage extends StatefulWidget {
  const TurtlesPage({Key? key}) : super(key: key);

  @override
  State<TurtlesPage> createState() => _TurtlesPageState();
}

class _TurtlesPageState extends State<TurtlesPage> {
  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();

    return Obx(() {
      int totalTurtles = 0;
      if (userController.user.value.unlockedTurtles.isNotEmpty &&
          userController.user.value.unlockedTurtleColors.isNotEmpty &&
          userController.user.value.unlockedTurtles.length ==
              userController.user.value.unlockedTurtleColors.length) {
        for (int i = 0;
            i < userController.user.value.unlockedTurtles.length;
            i++) {
          totalTurtles += userController.user.value.unlockedTurtleColors[i]
              .where((element) => element != -1)
              .toSet()
              .length;
        }
      }

      return DefaultTabController(
        length: 3,
        // initialIndex: totalTurtles == 0 ? 1 : 0,
        child: Scaffold(
          backgroundColor: Colors.grey[900],
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     PostHogService posthog = Get.find();
          //     posthog.logEvent('COLLECTIONS_PAGE_TAPPED', {});
          //     Get.to(const TrophyPage());
          //   },
          //   // child: const Text(
          //   //   '🏆',
          //   //   style: TextStyle(fontSize: 25),
          //   // ),
          //   child: const Icon(
          //     Icons.emoji_events,
          //     color: Colors.white,
          //   ),
          //   backgroundColor: Colors.cyan,
          //   // outline white 2
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(50),
          //     side: const BorderSide(color: Colors.white, width: 2),
          //   ),
          // ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey[900],
            title: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Turtles",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text("${totalTurtles + 1}",
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),

                Tab(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      const Text("TurtleDex",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      Text(
                          "${totalTurtles + 1}/${TURTLES.length * TURTLE_COLORS.length}",
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Tab(
                  child: Column(
                    children: const [
                      SizedBox(
                        height: 5,
                      ),
                      Text("Collections",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      Icon(
                        Icons.emoji_events,
                        // color: Colors.white,
                        size: 15,
                      )
                    ],
                  ),
                ),
                // Tab(
                //   child: Column(
                //     children: [
                //       const SizedBox(
                //         height: 5,
                //       ),
                //       const Text("Awards", style: TextStyle(fontSize: 18)),
                //       Text(userController.user.value.eggs.toString(),
                //           style: const TextStyle(fontSize: 12)),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              //Unlocked Turtles

              ListView(
                shrinkWrap: true,
                children: [
                  // Unlocked Turtles
                  userController.user.value.eggs == 0
                      ? Container()
                      : SizedBox(
                          // height: 200, // Adjust height as needed
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 8.0,
                            children: List.generate(
                              userController.user.value.eggs,
                              (index) => Center(child: EggCard(index: index)),
                            ),
                          ),
                        ),

                  SizedBox(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1,
                      children: userController.user.value.unlockedTurtleColors
                          .asMap()
                          .entries
                          .expand((entry) {
                        int turtleType = entry.key; // Turtle type index
                        List<int> colors = entry.value; // Unlocked colors

                        return colors
                            .where((color) => color != -1)
                            .map((color) {
                          return Center(
                            child: TurtleCardNew(
                              id: turtleType, // Turtle type
                              color: color, // Unlocked color
                              unlocked: true,
                              quantity: 1,
                            ),
                          );
                        });
                      }).toList(),
                    ),
                  ),
                ],
              ),
              ListView(children: [
                ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: List.generate(TURTLES.length, (index) {
                      return (userController
                                      .user.value.unlockedTurtles.isEmpty ||
                                  userController
                                          .user.value.unlockedTurtles[index] ==
                                      0) &&
                              index != 0
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: SizedBox(
                                height: 100,
                                child: Center(
                                  child: TurtleCategory(
                                      unlocked: true,
                                      id: index,
                                      displayColor: index == 0
                                          ? 0
                                          : userController.user.value
                                                  .unlockedTurtleColors[index]
                                                  .contains(0)
                                              ? 0
                                              : userController.user.value
                                                  .unlockedTurtleColors[index]
                                                  .where((element) =>
                                                      element != -1)
                                                  .toList()[0],
                                      uniqueQuantity: userController.user.value
                                          .unlockedTurtleColors[index]
                                          .where((element) => element != -1)
                                          .toSet()
                                          .toList()
                                          .length),
                                ),
                              ),
                            );
                    })),

                //Locked Turtles
                ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: List.generate(TURTLES.length, (index) {
                      return userController
                                  .user.value.unlockedTurtles.isEmpty ||
                              userController
                                      .user.value.unlockedTurtles[index] ==
                                  0
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: SizedBox(
                                height: 100,
                                child: Center(
                                  child: TurtleCategory(
                                      unlocked: false,
                                      id: index,
                                      displayColor: 0,
                                      uniqueQuantity: 0),
                                ),
                              ),
                            )
                          : Container();
                    })),
              ]),
              const TrophyPage(),
            ],
          ),
        ),
      );
    });
  }
}
