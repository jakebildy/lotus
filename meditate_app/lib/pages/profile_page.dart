import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/streak_chart.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/controllers/login_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/signup_controller.dart';
import 'package:meditate_app/pages/streak_count_page.dart';
import 'package:meditate_app/util/util.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    SaveController saveController = Get.find();
    AuthController auth = Get.find();
    return Obx(
      () => ListView(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10.0),
              child: Container(
                  height: 80,
                  child: auth.user.value.avatar == null
                      ? Image.asset("assets/profile_selected.png")
                      : Center(
                          child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(60)),
                              child: Image.network(
                                auth.user.value.avatar,
                                fit: BoxFit.fill,
                              )),
                        ))),
          Text(
            auth.user.value.username,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            tier(),
            style: TextStyle(color: tierColor(), fontSize: 17),
            textAlign: TextAlign.center,
          ),
          Text(
            "Joined ${formatMonth(auth.user.value.createdAt)}",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
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
                              child:
                                  Image.asset(saveController.streakIconURL())),
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
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    )),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: 140,
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
                      "Followers / Following",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "You don't have any friends yet. Add some!",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 180,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 50,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 20,
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
                  ],
                )),
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
          SizedBox(
            height: 10,
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
