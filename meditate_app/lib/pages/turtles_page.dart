import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/egg_card.dart';
import 'package:meditate_app/components/turtle_category.dart';
import 'package:meditate_app/controllers/user_controller.dart';
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
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Turtles",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                          "$totalTurtles/${TURTLES.length * TURTLE_COLORS.length}",
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
                      const Text("Eggs", style: TextStyle(fontSize: 18)),
                      Text(userController.user.value.eggs.toString(),
                          style: const TextStyle(fontSize: 12)),
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
                    physics: const ClampingScrollPhysics(),
                    children: List.generate(TURTLES.length, (index) {
                      return userController
                                  .user.value.unlockedTurtles.isEmpty ||
                              userController
                                      .user.value.unlockedTurtles[index] ==
                                  0
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
                                      displayColor: userController.user.value
                                              .unlockedTurtleColors[index]
                                              .contains(0)
                                          ? 0
                                          : userController.user.value
                                              .unlockedTurtleColors[index]
                                              .where((element) => element != -1)
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

                const Divider(),

                //Locked Turtles
                ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: List.generate(TURTLES.length, (index) {
                    // Check if index is within the bounds of unlockedTurtles
                    if (index <
                        userController.user.value.unlockedTurtles.length) {
                      return userController.user.value.unlockedTurtles[index] >
                              0
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: SizedBox(
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
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: SizedBox(
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
                    }
                  }),
                ),
              ]),
              userController.user.value.eggs == 0
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
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
                      children: List.generate(userController.user.value.eggs,
                          (index) {
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
