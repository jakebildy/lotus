import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/app_pages_controller.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/signup/checklist/checklist_item.dart';
import 'package:meditate_app/util/util.dart';

class OnboardingChecklistPage extends StatelessWidget {
  const OnboardingChecklistPage({super.key});

  //Check add profile picture with userController
  //Check add a friend with followController
  //Check Meditate for the first time with totalMinutes != 0
  //Add a triedBreathwork boolean to user model
  //Add a usedStreakFreezes boolean to user model

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();
    FollowController follow = Get.find();
    AppPagesController appPages = Get.find();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Your First Steps'),
        ),
        body: Column(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Stack(
                  children: [
                    Container(
                      height: 8,
                      width: MediaQuery.of(context).size.width - 70,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(56, 33, 156, 243),
                        borderRadius: BorderRadius.circular(20),
                        border: const Border.fromBorderSide(
                            BorderSide(color: Colors.transparent, width: 2)),
                      ),
                    ),
                    Container(
                      height: 8,
                      width: (MediaQuery.of(context).size.width - 70) *
                          calculateOnboardingPercentage(
                              user.user.value.totalMinutes > 0,
                              user.user.value.avatar !=
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                              user.user.value.hasTriedStreakFreeze ||
                                  user.user.value.streakFreezes > 0,
                              follow.usersFollowing.isNotEmpty,
                              user.user.value.hasTriedBreathwork) /
                          100,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(20),
                        border: const Border.fromBorderSide(
                            BorderSide(color: Colors.transparent, width: 2)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    calculateOnboardingPercentage(
                                user.user.value.totalMinutes > 0,
                                user.user.value.avatar !=
                                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                user.user.value.hasTriedStreakFreeze ||
                                    user.user.value.streakFreezes > 0,
                                follow.usersFollowing.isNotEmpty,
                                user.user.value.hasTriedBreathwork)
                            .toString() +
                        "%",
                    style: const TextStyle(color: Colors.lightBlue)),
              )
            ],
          ),

          // checklist
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const ChecklistItem(
                  text: "Create an account 🎉",
                  checked: true,
                  action: null,
                ),
                const Divider(),
                ChecklistItem(
                    text: "Meditate for the first time 🪷",
                    checked: user.user.value.totalMinutes > 0,
                    action: () {
                      appPages.switchPage(0);
                      Get.offAll(const AppPages());
                    }),
                const Divider(),
                ChecklistItem(
                    text: "Add a profile picture 📸",
                    checked: user.user.value.avatar !=
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                    action: () {
                      appPages.switchPage(3);
                      Get.offAll(const AppPages());
                    }),
                const Divider(),
                ChecklistItem(
                    text: "Get a streak freeze 🔥",
                    checked: user.user.value.hasTriedStreakFreeze ||
                        user.user.value.streakFreezes > 0,
                    action: () {
                      appPages.switchPage(1);
                      Get.offAll(const AppPages());
                    }),
                const Divider(),
                ChecklistItem(
                    text: "Add a friend 👋",
                    checked: follow.usersFollowing.isNotEmpty,
                    action: () {
                      appPages.switchPage(3);
                      Get.offAll(const AppPages());
                    }),
                const Divider(),
                ChecklistItem(
                    text: "Try breathwork 🌬️",
                    checked: user.user.value.hasTriedBreathwork,
                    action: () {
                      appPages.switchPage(0);
                      Get.offAll(const AppPages());
                    }),
                const Divider(),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
