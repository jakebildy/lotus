import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/follower_widget.dart';
import 'package:meditate_app/components/streak_chart.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/login_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/search_controller.dart';
import 'package:meditate_app/controllers/signup_controller.dart';
import 'package:meditate_app/models/follow.dart';
import 'package:meditate_app/pages/edit_profile/edit_profile.dart';
import 'package:meditate_app/pages/meditation_guide_page.dart';
import 'package:meditate_app/pages/search/search.dart';
import 'package:meditate_app/pages/stats_page.dart';
import 'package:meditate_app/pages/streak_count_page.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    SaveController saveController = Get.find();
    AuthController auth = Get.find();
    FollowController followController;
    if (Get.isRegistered<FollowController>()) {
      followController = Get.find();
    } else {
      followController = Get.put(FollowController());
    }
    if (!Get.isRegistered<SearchController>()) {
      Get.put(SearchController());
    }

    return Obx(
      () => ListView(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10.0),
              child: Center(
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(60)),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                        height: 80,
                        child: auth.user.value.avatar == null
                            ? Image.asset("assets/profile_selected.png")
                            : Center(
                                child: Hero(
                                  tag: "profile_picture",
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(60)),
                                      child: Image.network(
                                        auth.user.value.avatar,
                                        fit: BoxFit.fill,
                                      )),
                                ),
                              )),
                  ),
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                auth.user.value.fullName,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "(@" + auth.user.value.username + ")",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            tierReadable(saveController.streakTier()),
            style: TextStyle(
                color: tierColor(saveController.streakTier()), fontSize: 17),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Joined ${formatMonth(auth.user.value.createdAt)}",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1.0, color: Colors.white24),
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {
                      Get.to(EditProfile());
                    },
                    child: Text("Edit Profile",
                        style: TextStyle(color: Colors.grey))),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Get.to(StatsPage());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 5.0),
                            child: Container(
                                height: 30,
                                child: Hero(
                                  tag: "STREAK_STATS_ICON",
                                  child: Image.asset(
                                      saveController.streakIconURL()),
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                saveController.streak.value.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Day streak",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      )),
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
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            saveController.totalMinutes.value.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Total Minutes",
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: 250,
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
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Minutes meditated this week",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StreakChart(
                      height: 180,
                    ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
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
                    SizedBox(
                      height: 10,
                    ),
                    TabBar(
                        controller: tabController,
                        onTap: (int val) {
                          setState(() {
                            selectedTab = val;
                          });
                        },
                        tabs: [
                          Tab(
                            text: "Following",
                          ),
                          Tab(
                            text: "Followers",
                          )
                        ]),
                    Container(
                      height: 40 +
                          (selectedTab == 0
                              ? followController.stylistsFollowing.length * 64
                              : followController.followers.length * 64),
                      child: TabBarView(
                          controller: tabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            followController.stylistsFollowing.length == 0
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "You don't have any friends yet - add some!",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  )
                                : Column(children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ...(followController.stylistsFollowing.map(
                                        (user) => FollowerWidget(
                                            user: user,
                                            color: Color.fromARGB(
                                                255, 42, 42, 42))))
                                  ]),
                            followController.followers.length == 0
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "You don't have any followers yet!",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  )
                                : Column(children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ...(followController.followers.map((user) =>
                                        FollowerWidget(
                                            user: user,
                                            color: Color.fromARGB(
                                                255, 42, 42, 42))))
                                  ]),
                          ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(Search());
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 180,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      border: Border.all(
                                        color: Colors.white24,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 5, 5.0),
                                            child: Container(
                                                height: 17,
                                                child: Icon(
                                                  Icons.person_add,
                                                  color: Colors.tealAccent,
                                                  size: 20,
                                                ))),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "ADD FRIENDS",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 340,
              decoration: BoxDecoration(
                color: Colors.black12,
                border: Border.all(
                  color: Colors.white24,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.16,
                        child: Hero(
                          tag: "STREAK_STATS_ICON",
                          child: Image.asset(
                              saveController.streakIconURLBBright()),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
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
                                "Higher levels can find rarer turtles from Lotus Island.\n\nReach new levels by increasing your average meditation length for a week.\n")),
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  border: Border.all(
                    color: Colors.white24,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "People you may know",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //Only showing people with active streaks to make the app feel more engaging/active
                      ...(followController.stylistsNotFollowing
                          .where((p0) => p0.streak > 0)
                          .map((user) => FollowerWidget(
                              user: user,
                              color: Color.fromARGB(255, 42, 42, 42)))),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                Get.to(MeditationGuide(time: null));
              },
              child: Center(
                  child: Text(
                "How to Meditate",
                style: TextStyle(fontWeight: FontWeight.bold),
              ))),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
              onTap: () {
                AuthController authController = Get.find();
                authController.logoutRequest();
              },
              child: Center(
                  child: Text(
                "Sign Out",
                style: TextStyle(fontWeight: FontWeight.bold),
              )))
        ],
      ),
    );
  }
}
