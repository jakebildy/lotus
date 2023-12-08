import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/controllers/network_status_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/begin_meditation_page.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/pages/loading_page.dart';
import 'package:meditate_app/pages/profile_page.dart';
import 'package:meditate_app/pages/signup/signup.dart';
import 'package:meditate_app/pages/stats_page.dart';
import 'package:meditate_app/pages/turtles_page.dart';

import 'pages/shop_page.dart';

class AppPages extends StatefulWidget {
  const AppPages({Key? key}) : super(key: key);

  @override
  State<AppPages> createState() => _AppPagesState();
}

class _AppPagesState extends State<AppPages> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    SaveController saveController = Get.find();
    UserController userController = Get.find();
    NetworkStatusController network = Get.find();
    bool isDarkMode = true;

    return Obx(
      () => Stack(
        children: [
          userController.user.value == noUser && network.offline.value == false
              ? const Signup()
              : Scaffold(
                  appBar: PreferredSize(
                    preferredSize:
                        Size.fromHeight(network.offline.value ? 66 : 56),
                    child: AppBar(
                        elevation: 1,
                        backgroundColor: Colors.grey[850],
                        centerTitle: true,
                        title: Column(
                          children: [
                            network.offline.value
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.cloud_off_outlined,
                                        size: 12,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        "YOU ARE OFFLINE",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                : Container(),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(const StatsPage());
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                height: 27,
                                                child: Image.asset(
                                                    saveController
                                                        .streakIconURL())),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 4.0, 0, 0),
                                              child: Text(
                                                userController.user.value.streak
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: userController
                                                                    .user
                                                                    .value
                                                                    .streak ==
                                                                0 ||
                                                            !saveController
                                                                .hasDoneStreakToday
                                                                .value
                                                        ? DateTime.now().hour >
                                                                    21 &&
                                                                userController
                                                                        .user
                                                                        .value
                                                                        .streak >
                                                                    0
                                                            ? Colors.red
                                                            : Colors.grey
                                                        : isDarkMode
                                                            ? Colors.white
                                                            : Colors.black),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        )),
                                  ),

                                  // Column(
                                  //   children: [
                                  //      Text("You've meditated for",
                                  //     style: TextStyle( fontSize: 13,  color: isDarkMode ? Colors.white70 : Colors.grey),),
                                  //     Text("${saveController.totalMinutes} min",
                                  //     style: TextStyle( fontSize: 20,  color: isDarkMode ? Colors.white : Colors.black),),
                                  //   ],
                                  // ),

                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _page = 1;
                                      });
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                                height: 27,
                                                child: Image.asset(
                                                    "assets/sand_dollar.png")),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 4.0, 0, 0),
                                              child: Text(
                                                userController.user.value.gems
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: userController.user
                                                                .value.gems ==
                                                            0
                                                        ? Colors.grey
                                                        : isDarkMode
                                                            ? Colors.white
                                                            : Colors.black),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                  body: _page == 0
                      ? const BeginMeditationPage()
                      : _page == 1
                          ? const ShopPage()
                          : _page == 2
                              ? const TurtlesPage()
                              : const ProfilePage(),
                  bottomNavigationBar: BottomNavigationBar(
                      onTap: ((value) => setState(() {
                            _page = value;
                          })),
                      currentIndex: _page,
                      type: BottomNavigationBarType.fixed,
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      items: [
                        BottomNavigationBarItem(
                            icon: _page == 0
                                ? Container(
                                    height: 35,
                                    child: Image.asset(
                                        "assets/meditate_selected.png"))
                                : Container(
                                    height: 35,
                                    child: Image.asset(
                                        "assets/meditate_unselected.png")),
                            label: "Home"),
                        BottomNavigationBarItem(
                            icon: _page == 1
                                ? Container(
                                    height: 30,
                                    child: Image.asset(
                                        "assets/store_selected.png"))
                                : Container(
                                    height: 30,
                                    child: Image.asset(
                                        "assets/store_unselected.png")),
                            label: "Shop"),
                        BottomNavigationBarItem(
                            icon: _page == 2
                                ? Container(
                                    height: 35,
                                    child: Image.asset(
                                        "assets/turtle_selected.png"))
                                : Container(
                                    height: 35,
                                    child: Image.asset(
                                        "assets/turtle_unselected.png")),
                            label: "Turtles"),
                        BottomNavigationBarItem(
                            icon: _page == 3
                                ? Container(
                                    height: 30,
                                    child: Image.asset(
                                        "assets/profile_selected.png"))
                                : Container(
                                    height: 30,
                                    child: Image.asset(
                                        "assets/profile_unselected.png")),
                            label: "Profile"),
                      ]),
                ),
          userController.isLoading.value ||
                  userController.isLoadingPageNotDone.value
              ? const LoadingPage()
              : Container(
                  height: 0,
                )
        ],
      ),
    );
  }
}
