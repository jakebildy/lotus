import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/user_streak_chart.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/util.dart';

import '../../models/user.dart';

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
    SaveController saveController = Get.find();
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
                      child: Container(
                          height: 80,
                          child: widget.user.avatar == null
                              ? Image.asset("assets/profile_selected.png")
                              : Center(
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(60)),
                                      child: Image.network(
                                        widget.user.avatar,
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
            Text(
              tierReadable(userStreakTier(widget.user)),
              style: TextStyle(
                  color: tierColor(userStreakTier(widget.user)), fontSize: 17),
              textAlign: TextAlign.center,
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
                            child: Container(
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
                                widget.user.streak.toString(),
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
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
