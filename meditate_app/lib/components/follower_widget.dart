import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/pages/user_profile/user_profile_page.dart';
import 'package:meditate_app/services/heap_service.dart';
import 'package:meditate_app/util/util.dart';

class FollowerWidget extends StatelessWidget {
  final User user;
  final Color color;

  const FollowerWidget({Key? key, required this.user, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FollowController follow = Get.find();
    UserController userController = Get.find();
    return Obx(
      () => GestureDetector(
        onTap: () {
          Get.to(UserProfilePage(user: user));
        },
        child: Container(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                            height: 40,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(user.avatar))),
                        const SizedBox(
                          width: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${user.streak}",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                                SizedBox(
                                    height: 13,
                                    child:
                                        Image.asset(userStreakIconURL(user))),
                                Text(
                                  " • ${user.totalMinutes} min total",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    userController.user.value.id == user.id
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          width: 1.0, color: Colors.white),
                                      shape: const StadiumBorder(),
                                    ),
                                    onPressed: () {},
                                    child: const Text("You",
                                        style:
                                            TextStyle(color: Colors.white)))))
                        : follow.usersFollowing
                                .map((element) => element.id)
                                .contains(user.id)
                            ? const Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                    height: 40,
                                    child:
                                        Icon(Icons.arrow_forward_ios_rounded)))
                            : Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            width: 1.0, color: Colors.teal),
                                        shape: const StadiumBorder(),
                                      ),
                                      onPressed: () {
                                        follow.followStylist(user);
                                        //Log the event to AppsFlyer
                                        HeapService appsflyer = Get.find();
                                        appsflyer.logEvent("FOLLOW", {});
                                      },
                                      child: const Text("Follow",
                                          style: TextStyle(
                                              color: Colors.tealAccent))),
                                ),
                              )
                  ],
                ),
                const Divider()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
