import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/signup/checklist/checklist_item.dart';

class OnboardingChecklistPage extends StatelessWidget {
  const OnboardingChecklistPage({super.key});

  //TODO: Add ChecklistItem widget (has boolean checked, and text)

  //Check add profile picture with userController
  //Check add a friend with followController
  //Check Meditate for the first time with totalMinutes != 0
  //Add a triedBreathwork boolean to user model
  //Add a usedStreakFreezes boolean to user model

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();
    FollowController follow = Get.find();
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
                        color: Color.fromARGB(56, 33, 156, 243),
                        borderRadius: BorderRadius.circular(20),
                        border: const Border.fromBorderSide(
                            BorderSide(color: Colors.transparent, width: 2)),
                      ),
                    ),
                    Container(
                      height: 8,
                      width: (MediaQuery.of(context).size.width - 70) * 0.4,
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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("28%", style: TextStyle(color: Colors.lightBlue)),
              )
            ],
          ),

          // checklist
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const ChecklistItem(text: "Create an account", checked: true),
                const Divider(),
                ChecklistItem(
                    text: "Meditate for the first time",
                    checked: user.user.value.totalMinutes > 0),
                const Divider(),
                ChecklistItem(
                    text: "Add a profile picture",
                    checked: user.user.value.avatar !=
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                const Divider(),
                ChecklistItem(
                    text: "Add a friend",
                    checked: follow.usersFollowing.isNotEmpty),
                const Divider(),
                ChecklistItem(
                    text: "Protect your streak with streak freezes",
                    checked: false),
                const Divider(),
                ChecklistItem(text: "Try breathwork", checked: false),
                Divider(),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
