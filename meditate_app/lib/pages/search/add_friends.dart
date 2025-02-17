import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/search/friend_suggestions.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:share_plus/share_plus.dart';

import 'search.dart';

class AddFriends extends StatelessWidget {
  const AddFriends({super.key});

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: const Text(
          "",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      backgroundColor: Colors.grey[900],
      body: ListView(children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Add my friends",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Start your meditation circle by inviting friends!"),
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
                      PostHogService posthog = Get.find();
                      posthog.logEvent("ADD_FRIENDS_LINK_TAPPED", {});
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[800]!, width: 2),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                onTap: () {
                  PostHogService posthog = Get.find();
                  posthog.logEvent("GO_TO_SEARCH_PAGE_TAPPED", {});
                  Get.to(() => const Search());
                },
                // border
                title: const Text(
                  "Search by username",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                leading: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.search,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 60,
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
    );
  }
}
