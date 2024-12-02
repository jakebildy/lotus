import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/follower_widget.dart';
import 'package:meditate_app/controllers/follow_controller.dart';

class FriendSuggestions extends StatelessWidget {
  const FriendSuggestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final followController = Get.find<FollowController>();

    return Obx(() {
      if (followController.loadingFollowers.value) {
        return const CircularProgressIndicator();
      }

      final users = followController.combinedUsers;

      if (users.isEmpty) {
        return const Text('No suggestions available.');
      }

      return Column(
        children: users
            .map((user) => FollowerWidget(user: user, color: Colors.grey[900]!))
            .toList(),
      );
    });
  }
}
