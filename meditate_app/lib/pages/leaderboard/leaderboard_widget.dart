import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/pages/user_profile/user_profile_page.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/util.dart';

class LeaderboardWidget extends StatelessWidget {
  final User user;
  final Color color;

  const LeaderboardWidget({Key? key, required this.user, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();
    final DateTime lastSentAtUtc =
        user.emojisSentAt[userController.user.value.id] ??
            DateTime.now().toUtc();
    final DateTime nowUtc = DateTime.now().toUtc();
    final Duration difference = nowUtc.difference(lastSentAtUtc);

    return Obx(
      () => GestureDetector(
        onTap: () {
          PostHogService posthog = Get.find();
          posthog.logEvent("VIEW_USER_PROFILE", {});

          Get.to(UserProfilePage(user: user), preventDuplicates: false);
        },
        child: Container(
          // color: color,
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
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                              child: SizedBox(
                                  height: 40,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: user.avatar ==
                                                  "https://i.imgur.com/BIRdTgg.png" ||
                                              user.avatar ==
                                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                                          ? Image.asset(
                                              "assets/blank_profile.png",
                                              height: 40,
                                              fit: BoxFit.cover,
                                            )
                                          : FadeInImage.assetNetwork(
                                              placeholder:
                                                  'assets/blank_profile.png',
                                              image: user.avatar,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            ))),
                            ),
                            Text(
                              user.sentEmojis[userController.user.value.id]
                                          .toString() !=
                                      "null"
                                  ? difference < const Duration(hours: 24)
                                      ? user.sentEmojis[
                                              userController.user.value.id]
                                          .toString()
                                      : ""
                                  : "",
                              style: const TextStyle(fontSize: 20),
                            ),
                            DateTime.now()
                                            .difference(user.updatedAt)
                                            .inMinutes <
                                        30 &&
                                    user.sentEmojis[
                                                userController.user.value.id]
                                            .toString() ==
                                        "null"
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 6, 6),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[900],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ))
                                : Container()
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Column(
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
                                  getUserStreak(user) == 0
                                      ? Container()
                                      : SizedBox(
                                          height: 13,
                                          child: Image.asset(
                                              userStreakIconURL(user))),
                                  getUserStreak(user) == 0
                                      ? DateTime.now()
                                                  .difference(user.updatedAt)
                                                  .inDays <
                                              30
                                          ? Text(
                                              DateTime.now()
                                                          .difference(
                                                              user.updatedAt)
                                                          .inDays >
                                                      0
                                                  ? (DateTime.now()
                                                          .difference(
                                                              user.updatedAt)
                                                          .inDays
                                                          .toString() +
                                                      "d")
                                                  : (DateTime.now()
                                                              .difference(user
                                                                  .updatedAt)
                                                              .inHours ==
                                                          0
                                                      ? "1h"
                                                      : DateTime.now()
                                                              .difference(user
                                                                  .updatedAt)
                                                              .inHours
                                                              .toString() +
                                                          "h"),
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14),
                                            )
                                          : Container()
                                      : Text(
                                          " ${getUserStreak(user)} ${userAdditionalEmoji(user)}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                  getUserStreak(user) == 0 &&
                                          DateTime.now()
                                                  .difference(user.updatedAt)
                                                  .inDays >
                                              30
                                      ? Text(
                                          "Level ${calculateLevel(user.levelPoints, user)}  (${user.levelPoints + calculateUserTotalXPFromCollections(user)} XP)",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        )
                                      : Text(
                                          " • Level ${calculateLevel(user.levelPoints, user)} (${user.levelPoints + calculateUserTotalXPFromCollections(user)} XP)",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // userController.user.value.id == user.id
                    //     ? Align(
                    //         alignment: Alignment.centerRight,
                    //         child: Padding(
                    //             padding: const EdgeInsets.all(0.0),
                    //             child: OutlinedButton(
                    //                 style: OutlinedButton.styleFrom(
                    //                   side: const BorderSide(
                    //                       width: 1.0, color: Colors.white),
                    //                   shape: const StadiumBorder(),
                    //                 ),
                    //                 onPressed: () {},
                    //                 child: const Text("You",
                    //                     style:
                    //                         TextStyle(color: Colors.white)))))
                    //     : follow.usersFollowing
                    //             .map((element) => element.id)
                    //             .contains(user.id)
                    //         ? const Align(
                    //             alignment: Alignment.centerRight,
                    //             child: SizedBox(
                    //                 height: 40,
                    //                 child:
                    //                     Icon(Icons.arrow_forward_ios_rounded)))
                    //         : Align(
                    //             alignment: Alignment.centerRight,
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(0.0),
                    //               child: OutlinedButton(
                    //                   style: OutlinedButton.styleFrom(
                    //                     side: const BorderSide(
                    //                         width: 1.0, color: Colors.teal),
                    //                     shape: const StadiumBorder(),
                    //                   ),
                    //                   onPressed: () {
                    //                     // follow.followStylist(user);
                    //                     // //Log the event to PostHog
                    //                     // PostHogService posthog = Get.find();
                    //                     // posthog.logEvent("FOLLOW", {});
                    //                   },
                    //                   child: const Text("Follow",
                    //                       style: TextStyle(
                    //                           color: Colors.tealAccent))),
                    //             ),
                    //           )
                  ],
                ),
                const Divider(height: 0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
