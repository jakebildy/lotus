import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/search/friend_suggestions.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:share_plus/share_plus.dart';

class AddSomeonePage extends StatefulWidget {
  const AddSomeonePage({super.key});

  @override
  State<AddSomeonePage> createState() => _AddSomeonePageState();
}

class _AddSomeonePageState extends State<AddSomeonePage> {
  bool shareLinkTapped = false;

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find<UserController>();
    FollowController follow = Get.find<FollowController>();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          elevation: 0,
          title: const Text(
            "",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: Container(),
        ),
        backgroundColor: Colors.grey[900],
        bottomNavigationBar: Container(
            child: Container(
                color: Colors.grey[900],
                height: 100,
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: follow.usersFollowing.isNotEmpty || shareLinkTapped
                      ? GestureDetector(
                          onTap: () {
                            PostHogService posthog = Get.find();
                            posthog.logEvent("CONTINUE_ADD_FRIENDS_TAPPED", {});
                            Get.offAll(const AppPages());
                          },
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 16, 77, 127),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 100),
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              )))
                      : GestureDetector(
                          onTap: () {
                            PostHogService posthog = Get.find();
                            posthog.logEvent("SKIP_ADD_FRIENDS_TAPPED", {});
                            Get.offAll(const AppPages());
                          },
                          child: const Text(
                            "Skip",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                )))),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white, // Default text color
                ),
                children: [
                  TextSpan(text: "Adding a friend makes you\n"),
                  TextSpan(
                    text: " more likely",

                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(
                            255, 95, 220, 255)), // Blue color for "more likely"
                  ),
                  TextSpan(text: " to keep your streak going!"),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          shareLinkTapped = true;
                        });

                        PostHogService posthog = Get.find();
                        posthog.logEvent("ADD_FRIENDS_LINK_TAPPED", {});

                        posthog.logEvent(
                            "ADD_FRIENDS_LINK_TAPPED_ADD_SOMEONE_PAGE", {});
                        HapticFeedback.mediumImpact();
                        Share.share("Add me on Shellevate! My username is @" +
                            user.user.value.username +
                            "\n\n https://shellevate.app/get");
                      },
                      title: const Text(
                        "Share link",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.tealAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(user.user.value.avatar)),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.ios_share_outlined,
                                  color: Colors.tealAccent,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ))),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //         border: Border.all(color: Colors.grey[800]!, width: 2),
          //         borderRadius: BorderRadius.circular(10)),
          //     child: Padding(
          //       padding: const EdgeInsets.all(5.0),
          //       child: ListTile(
          //         onTap: () {
          //           PostHogService posthog = Get.find();
          //           posthog.logEvent("GO_TO_SEARCH_PAGE_TAPPED", {});
          //           Get.to(() => const Search());
          //         },
          //         // border
          //         title: const Text(
          //           "Search by username",
          //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //         ),
          //         leading: const Padding(
          //           padding: EdgeInsets.all(8.0),
          //           child: Icon(
          //             Icons.search,
          //             size: 40,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Friend suggestions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: FriendSuggestions(),
          ),
        ]),
      ),
    );
  }
}
