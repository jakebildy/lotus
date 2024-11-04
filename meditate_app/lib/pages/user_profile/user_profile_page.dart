import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/follower_widget.dart';
import 'package:meditate_app/components/user_streak_chart.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';

import '../../components/turtle_image.dart';
import '../../models/user.dart';
import 'send_vibe_widget.dart';

class UserProfilePage extends StatefulWidget {
  final User user;
  const UserProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
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
    FollowController followController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text("@" + widget.user.username),
        elevation: 0,
        backgroundColor: Colors.grey[850],
      ),
      body: Obx(
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
                      child: SizedBox(
                          height: 80,
                          child: Center(
                            child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(60)),
                                child: widget.user.avatar ==
                                            "https://i.imgur.com/BIRdTgg.png" ||
                                        widget.user.avatar ==
                                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                                    ? Image.asset(
                                        "assets/blank_profile.png",
                                        // height: 40,
                                        fit: BoxFit.fill,
                                      )
                                    : FadeInImage.assetNetwork(
                                        placeholder: 'assets/blank_profile.png',
                                        image: widget.user.avatar,
                                        // height: 40,
                                        fit: BoxFit.fill,
                                      )),
                          )),
                    ),
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.user.fullName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "(@" + widget.user.username + ")",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Level " + calculateLevel(widget.user.levelPoints).toString(),
                  style: const TextStyle(color: Colors.green, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
                followController.meditationAmounts.isEmpty ||
                        calculateTopPercentile(
                                followController.meditationAmounts.toList(),
                                widget.user.totalMinutes) >
                            50
                    ? Container()
                    : Text(
                        " (Top " +
                            calculateTopPercentile(
                                    followController.meditationAmounts.toList(),
                                    widget.user.totalMinutes)
                                .toString() +
                            "%)",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Joined ${formatMonth(widget.user.createdAt)}",
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
                        side: BorderSide(
                            width: 1.0,
                            color:
                                userController.user.value.id == widget.user.id
                                    ? Colors.white
                                    : followController.usersFollowing
                                            .map((element) => element.id)
                                            .contains(widget.user.id)
                                        ? Colors.white24
                                        : Colors.teal),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        if (userController.user.value.id != widget.user.id) {
                          followController.followStylist(widget.user);
                        }
                      },
                      child: Text(
                          userController.user.value.id == widget.user.id
                              ? "You"
                              : followController.usersFollowing
                                      .map((element) => element.id)
                                      .contains(widget.user.id)
                                  ? "Following"
                                  : "Follow",
                          style: TextStyle(
                              color:
                                  userController.user.value.id == widget.user.id
                                      ? Colors.white
                                      : followController.usersFollowing
                                              .map((element) => element.id)
                                              .contains(widget.user.id)
                                          ? Colors.grey
                                          : Colors.tealAccent))),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
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
                            child: SizedBox(
                                height: 30,
                                child: Image.asset(
                                    userStreakIconURL(widget.user))),
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
                                getUserStreak(widget.user).toString(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                            widget.user.totalMinutes.toString(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Total Minutes",
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      )),
                ),
              ],
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
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Minutes they meditated this week",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      UserStreakChart(
                        user: widget.user,
                        height: 180,
                      ),
                    ],
                  )),
            ),

            // Display the user's turtles
            widget.user.unlockedTurtleColors
                    .map((list) => list.where((color) => color != -1).toList())
                    .where((list) => list.isNotEmpty)
                    .toList()
                    .isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        border: Border.all(
                          color: Colors.white24,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal, // To scroll horizontally
                        child: Row(
                          children: widget.user.unlockedTurtleColors
                              .sublist(0, TURTLES.length)
                              .asMap() // Convert list to map to get index
                              .entries
                              .expand((entry) => entry.value
                                  .where((color) =>
                                      color != -1) // Filter out -1 values
                                  .map((color) => Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: TurtleImage(
                                          id: entry.key,
                                          color:
                                              color, // Assuming `color` is the desired type for TurtleImage
                                        ),
                                      )))
                              .toList(),
                        ),
                      ),
                    ),
                  ),

            const SizedBox(
              height: 10,
            ),
            followController.followers
                    .map((element) => element.id)
                    .contains(widget.user.id)
                ? SendVibeWidget(
                    targetUserId: widget.user.id ?? "",
                  )
                : Container(),

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
                        tabs: [
                          Tab(
                            text: "Following (" +
                                followController
                                    .getAllUsersFollowing(widget.user)
                                    .length
                                    .toString() +
                                ")",
                          ),
                          Tab(
                            text: "Followers (" +
                                followController
                                    .getAllUsersFollowedBy(widget.user)
                                    .length
                                    .toString() +
                                ")",
                          )
                        ]),
                    SizedBox(
                      height: 40 +
                          (selectedTab == 0
                              ? followController
                                      .getAllUsersFollowing(widget.user)
                                      .length *
                                  72
                              : followController
                                      .getAllUsersFollowedBy(widget.user)
                                      .length *
                                  72),
                      child: TabBarView(
                          controller: tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            followController
                                    .getAllUsersFollowing(widget.user)
                                    .isEmpty
                                ? Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        widget.user.fullName +
                                            " isn't following anyone yet.",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  )
                                : Column(children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ...(followController
                                        .getAllUsersFollowing(widget.user)
                                        .map((user) => FollowerWidget(
                                            user: user,
                                            color: const Color.fromARGB(
                                                255, 42, 42, 42))))
                                  ]),
                            followController
                                    .getAllUsersFollowedBy(widget.user)
                                    .isEmpty
                                ? Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        widget.user.fullName +
                                            " doesn't have any followers yet - be their first?",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  )
                                : Column(children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ...(followController
                                        .getAllUsersFollowedBy(widget.user)
                                        .map((user) => FollowerWidget(
                                            user: user,
                                            color: const Color.fromARGB(
                                                255, 42, 42, 42))))
                                  ]),
                          ]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
