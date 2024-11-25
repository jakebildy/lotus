import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:meditate_app/components/onboarding/onboarding_progress_bar.dart';
import 'package:meditate_app/controllers/app_pages_controller.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/network_status_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/begin_meditation_page.dart';
import 'package:meditate_app/pages/loading_page.dart';
import 'package:meditate_app/pages/profile_page.dart';
import 'package:meditate_app/pages/signup/signup.dart';
import 'package:meditate_app/pages/stats_page.dart';
import 'package:meditate_app/pages/turtles_page.dart';
import 'package:badges/badges.dart' as badges;
import 'package:meditate_app/util/util.dart';
import 'pages/shop_page.dart';

class AppPages extends StatefulWidget {
  const AppPages({Key? key}) : super(key: key);

  @override
  State<AppPages> createState() => _AppPagesState();
}

class _AppPagesState extends State<AppPages> {
  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();
    NetworkStatusController network = Get.find();
    AppPagesController appPages = Get.find();
    FollowController followController = Get.find();

    return Obx(
      () => Stack(
        children: [
          userController.user.value == noUser && network.offline.value == false
              ? const Signup()
              : Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: PreferredSize(
                    preferredSize:
                        Size.fromHeight(network.offline.value ? 66 : 56),
                    child: AppBar(
                        elevation: 0,
                        backgroundColor: appPages.page.value == 0
                            ? Colors.transparent
                            : Colors.grey[900],
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              child: Image.asset(userController
                                                  .streakIconURL())),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
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
                                                          !userController
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
                                                          : appPages.page
                                                                      .value ==
                                                                  0
                                                              ? Colors.grey
                                                              : Colors.grey
                                                      : Colors.white),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      )),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    appPages.switchPage(1);
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              height: 27,
                                              child: Image.asset(
                                                  "assets/sand_dollar.png")),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
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
                                                      : Colors.white),
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
                          ],
                        )),
                  ),
                  backgroundColor: Colors.grey[900],
                  body: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      appPages.page.value == 0
                          ? const BeginMeditationPage()
                          : appPages.page.value == 1
                              ? const ShopPage()
                              : appPages.page.value == 2
                                  ? const TurtlesPage()
                                  : const ProfilePage(),
                      appPages.page.value == 0 ||
                              calculateOnboardingPercentage(
                                      userController.user.value.totalMinutes >
                                          0,
                                      userController.user.value.avatar !=
                                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                      userController
                                              .user.value.hasTriedStreakFreeze ||
                                          userController
                                                  .user.value.streakFreezes >
                                              0,
                                      followController
                                              .usersFollowing.isNotEmpty ||
                                          followController
                                              .loadingFollowers.value ||
                                          network.offline.value,
                                      userController
                                          .user.value.hasTriedBreathwork) >=
                                  97
                          ? Container()
                          : const OnboardingProgressBar(),
                    ],
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                      backgroundColor: Colors.grey[900],
                      onTap: ((value) => setState(() {
                            appPages.page.value = value;
                          })),
                      currentIndex: appPages.page.value,
                      type: BottomNavigationBarType.fixed,
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      items: [
                        BottomNavigationBarItem(
                            icon: appPages.page.value == 0
                                ? SizedBox(
                                    height: 35,
                                    child: Image.asset(
                                        "assets/meditate_selected.png"))
                                : SizedBox(
                                    height: 35,
                                    child: Image.asset(
                                        "assets/meditate_unselected.png")),
                            label: "Home"),
                        BottomNavigationBarItem(
                            icon: appPages.page.value == 1
                                ? SizedBox(
                                    height: 30,
                                    child: Image.asset(
                                        "assets/store_selected.png"))
                                : badges.Badge(
                                    showBadge: userController
                                                    .user.value.streakFreezes <=
                                                2 &&
                                            userController.user.value.gems ~/
                                                    80 >=
                                                1
                                        ? true
                                        : false,
                                    badgeContent: Text(
                                      ((userController.user.value.gems ~/ 80 > 3
                                                  ? 3
                                                  : userController
                                                          .user.value.gems ~/
                                                      80) -
                                              userController
                                                  .user.value.streakFreezes)
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    position: badges.BadgePosition.bottomEnd(
                                        bottom: -4, end: -4),
                                    child: SizedBox(
                                        height: 30,
                                        child: Image.asset(
                                            "assets/store_unselected.png")),
                                  ),
                            label: "Shop"),
                        BottomNavigationBarItem(
                            icon: appPages.page.value == 2
                                ? SizedBox(
                                    height: 35,
                                    child: Image.asset(
                                        "assets/turtle_selected.png"))
                                : SizedBox(
                                    height: 35,
                                    child: Image.asset(
                                        "assets/turtle_unselected.png")),
                            label: "Turtles"),
                        BottomNavigationBarItem(
                            icon: appPages.page.value == 3
                                ? SizedBox(
                                    height: 30,
                                    child: Image.asset(
                                        "assets/profile_selected.png"))
                                : SizedBox(
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
