import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/follower_widget.dart';
import 'package:meditate_app/components/meditation_heatmap.dart';
import 'package:meditate_app/components/streak_chart.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/network_status_controller.dart';
import 'package:meditate_app/controllers/search_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/edit_profile/edit_profile.dart';
import 'package:meditate_app/pages/meditation_guide_page.dart';
import 'package:meditate_app/pages/search/search.dart';
import 'package:meditate_app/pages/stats_page.dart';
import 'package:meditate_app/services/heap_service.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';
import 'package:url_launcher/url_launcher.dart';

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
    UserController userController = Get.find();
    FollowController followController;
    if (Get.isRegistered<FollowController>()) {
      followController = Get.find();
    } else {
      followController = Get.put(FollowController());
    }
    if (!Get.isRegistered<SearchController>()) {
      Get.put(SearchController());
    }

    NetworkStatusController network = Get.find();

    return Obx(
      () => network.offline.value
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  SizedBox(
                      height: 240, child: Image.asset("assets/offline.png")),
                  const Text(
                    "Your profile is unavailable right now",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "You seem to be offline. Check your connection or try again later!",
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )
          : ListView(
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
                          child: SizedBox(
                              height: 80,
                              child: Center(
                                child: Hero(
                                  tag: "profile_picture",
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(60)),
                                      child: Image.network(
                                        userController.user.value.avatar,
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
                      userController.user.value.fullName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "(@" + userController.user.value.username + ")",
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  tierReadable(userController.streakTier()),
                  style: TextStyle(
                      color: tierColor(userController.streakTier()),
                      fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Joined ${formatMonth(userController.user.value.createdAt)}",
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                width: 1.0, color: Colors.white24),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            Get.to(const EditProfile());
                          },
                          child: const Text("   Edit Profile   ",
                              style: TextStyle(color: Colors.grey))),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0.0),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                width: 1.0, color: Colors.white),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () async {
                            final Uri url = Uri.parse('https://www.google.com');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: const Text("Send Feedback",
                              style: TextStyle(color: Colors.white))),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(const StatsPage());
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 5, 5.0),
                                  child: SizedBox(
                                      height: 30,
                                      child: Hero(
                                        tag: "STREAK_STATS_ICON",
                                        child: Image.asset(
                                            userController.streakIconURL()),
                                      )),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      userController.user.value.streak
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
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
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  userController.user.value.totalMinutes
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  "Total Minutes",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white70),
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
                        children: const [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Minutes meditated this week",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
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
                      height: 530,
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
                          const Text(
                            "My Meditation Calendar",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const MeditationHeatmap(
                            height: 240,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                (userController.streakTier() == Tier.ORANGE
                                    ? "Level 1: Hatchling"
                                    : userController.streakTier() == Tier.YELLOW
                                        ? "Level 2: Champion"
                                        : userController.streakTier() ==
                                                Tier.BLUE
                                            ? "Level 3: Expert"
                                            : "Level 4: Turtlemaster"),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color:
                                        tierColor(userController.streakTier())),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Higher levels can find rarer turtles.\n\nReach new levels by increasing your average meditation length for a week.\n",
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Hatchling: 0-10 Minutes/Day",
                                style: TextStyle(color: Colors.green),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Champion: 10-20 Minutes/Day",
                                  style: TextStyle(color: Colors.yellow)),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Expert: 20-40 Minutes/Day",
                                  style:
                                      TextStyle(color: Colors.lightBlueAccent)),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Turtlemaster: 40+ Minutes/Day",
                                  style: TextStyle(color: Colors.pink)),
                            ],
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
                          const SizedBox(
                            height: 10,
                          ),
                          TabBar(
                              controller: tabController,
                              onTap: (int val) {
                                setState(() {
                                  selectedTab = val;
                                });
                              },
                              tabs: const [
                                Tab(
                                  text: "Following",
                                ),
                                Tab(
                                  text: "Followers",
                                )
                              ]),
                          SizedBox(
                            height: 40 +
                                (selectedTab == 0
                                    ? followController.usersFollowing.length *
                                        64
                                    : followController.followers.length * 64),
                            child: TabBarView(
                                controller: tabController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  followController.usersFollowing.isEmpty
                                      ? Column(
                                          children: const [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "You don't have any friends yet - add some!",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      : Column(children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ...(followController.usersFollowing
                                              .map((user) => FollowerWidget(
                                                  user: user,
                                                  color: const Color.fromARGB(
                                                      255, 42, 42, 42))))
                                        ]),
                                  followController.followers.isEmpty
                                      ? Column(
                                          children: const [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "You don't have any followers yet!",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      : Column(children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ...(followController.followers.map(
                                              (user) => FollowerWidget(
                                                  user: user,
                                                  color: const Color.fromARGB(
                                                      255, 42, 42, 42))))
                                        ]),
                                ]),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              //Log the event to AppsFlyer
                              HeapService appsflyer = Get.find();
                              appsflyer.logEvent("ADD_FRIENDS_TAPPED", {});

                              Get.to(const Search());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 180,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                20,
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          border: Border.all(
                                            color: Colors.white24,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 5, 5.0),
                                                child: SizedBox(
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
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "People you may know",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            //Only showing people with active streaks to make the app feel more engaging/active
                            ...(followController.usersNotFollowing
                                .where((p0) => p0.streak > 0)
                                .map((user) => FollowerWidget(
                                    user: user,
                                    color: const Color.fromARGB(
                                        255, 42, 42, 42)))),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: () {
                      Get.to(const MeditationGuide(time: null));
                    },
                    child: const Center(
                        child: Text(
                      "How to Meditate",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                    onTap: () {
                      UserController userController = Get.find();
                      userController.logoutRequest();
                    },
                    child: const Center(
                        child: Text(
                      "Sign Out",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )))
              ],
            ),
    );
  }
}
