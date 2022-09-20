import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/pages/user_profile/user_profile_page.dart';
import 'package:meditate_app/util/util.dart';

class FollowerWidget extends StatelessWidget {
  final User user;
  final Color color;

  const FollowerWidget({Key? key, required this.user, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FollowController follow = Get.find();
    AuthController auth = Get.find();
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
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                            height: 40,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(user.avatar))),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${user.streak}",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                                Container(
                                    height: 13,
                                    child:
                                        Image.asset(userStreakIconURL(user))),
                                Text(
                                  " • ${user.totalMinutes} min total",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    auth.user.value.id == user.id
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          width: 1.0, color: Colors.white),
                                      shape: StadiumBorder(),
                                    ),
                                    onPressed: () {},
                                    child: Text("You",
                                        style:
                                            TextStyle(color: Colors.white)))))
                        : follow.stylistsFollowing
                                .map((element) => element.id)
                                .contains(user.id)
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    height: 40,
                                    child:
                                        Icon(Icons.arrow_forward_ios_rounded)))
                            : Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            width: 1.0, color: Colors.teal),
                                        shape: StadiumBorder(),
                                      ),
                                      onPressed: () {
                                        follow.followStylist(user);
                                      },
                                      child: Text("Follow",
                                          style: TextStyle(
                                              color: Colors.tealAccent))),
                                ),
                              )
                  ],
                ),
                Divider()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
