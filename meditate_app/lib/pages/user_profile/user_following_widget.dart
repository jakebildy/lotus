import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/follower_widget.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/models/user.dart';

class UserFollowingWidget extends StatefulWidget {
  final User user;
  const UserFollowingWidget({super.key, required this.user});

  @override
  State<UserFollowingWidget> createState() => _UserFollowingWidgetState();
}

class _UserFollowingWidgetState extends State<UserFollowingWidget>
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
    FollowController followController = Get.find();
    return Padding(
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
                height: 40.0 +
                    (selectedTab == 0
                        ? followController.usersFollowing.length * 64
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
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            )
                          : Column(children: [
                              const SizedBox(
                                height: 10,
                              ),
                              ...(followController.usersFollowing.map((user) =>
                                  FollowerWidget(
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
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            )
                          : Column(children: [
                              const SizedBox(
                                height: 10,
                              ),
                              ...(followController.followers.map((user) =>
                                  FollowerWidget(
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
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 5.0),
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
    );
  }
}
