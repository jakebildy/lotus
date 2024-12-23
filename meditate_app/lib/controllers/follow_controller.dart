import 'package:get/get.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/models/follow.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/api/index.dart' as api;
import 'package:meditate_app/util/logger.dart';

import '../util/util.dart';

/// FollowController handles following and unfollowing other users. Still have a bit of refactoring left to do.
/// {@category Controllers}
class FollowController extends GetxController {
  RxList<User> usersFollowing = RxList();
  RxList<User> usersNotFollowing = RxList();
  RxList<String> usersFollowingIDs = RxList();
  RxList<User> followers = RxList();
  RxList<Follow> following = RxList();
  RxList<Follow> allUserFollowers = RxList();
  RxBool loadingFollowers = false.obs;

  RxList<int> meditationAmounts = RxList();

  RxList<User> newFollowers = RxList();

  FollowController() {
    fetchFollows();
  }

  RxList<User> combinedUsers = <User>[].obs; // Filtered & sorted users

  // Updates `combinedUsers` based on `usersNotFollowing`
  void updateCombinedUsers() {
    final activeUsers = getActiveUsers(usersNotFollowing);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final newUsers = usersNotFollowing.where((user) {
      return user.createdAt.isAfter(today.subtract(const Duration(days: 3)));
    }).toList();

    // Combine and deduplicate active and new users
    combinedUsers.value = (activeUsers + newUsers).toSet().toList();
  }

  List<User> getActiveUsers(List<User> users) {
    // Only return users for whom lastMeditated was at most yesterday, OR lastMeditated was at most 2 days ago and they have one streak freeze, OR last meditated was 3 days ago and they have two streak freezes
    List<User> activeUsers = [];
    DateTime now = DateTime.now();
    // TODAY in the local time zone
    DateTime today = DateTime(now.year, now.month, now.day);
    logWarning(today.toIso8601String());
    for (User user in users) {
      // this also calculates the topPercent of totalMinutes of the user vs the other user. So if they're in the top 20% of users, for instance.
      meditationAmounts.add(user.totalMinutes);

      DateTime lastMeditatedAdjusted = DateTime(user.lastMeditated.year,
          user.lastMeditated.month, user.lastMeditated.day);
      logWarning(lastMeditatedAdjusted.toIso8601String());
      logInfo(user.fullName +
          " lastMeditated->" +
          user.lastMeditated.toString() +
          " created at->" +
          user.createdAt.toString() +
          " " +
          user.streakFreezes.toString());
      if (user.streakFreezes == 0) {
        if (lastMeditatedAdjusted
                .isAfter(today.subtract(const Duration(days: 1))) ||
            lastMeditatedAdjusted
                .isAtSameMomentAs(today.subtract(const Duration(days: 1)))) {
          activeUsers.add(user);
        }
      } else if (user.streakFreezes == 1) {
        if (lastMeditatedAdjusted
                .isAfter(today.subtract(const Duration(days: 2))) ||
            lastMeditatedAdjusted
                .isAtSameMomentAs(today.subtract(const Duration(days: 2)))) {
          activeUsers.add(user);
        }
      } else if (user.streakFreezes == 2) {
        if (lastMeditatedAdjusted
                .isAfter(today.subtract(const Duration(days: 3))) ||
            lastMeditatedAdjusted
                .isAtSameMomentAs(today.subtract(const Duration(days: 3)))) {
          activeUsers.add(user);
        }
      } else if (user.streakFreezes == 3) {
        if (lastMeditatedAdjusted
                .isAfter(today.subtract(const Duration(days: 4))) ||
            lastMeditatedAdjusted
                .isAtSameMomentAs(today.subtract(const Duration(days: 4)))) {
          activeUsers.add(user);
        }
      }
    }

    try {
      UserController user = Get.find();
      SaveController save = Get.find();
      save.updateTopPercentage(calculateTopPercentile(
          meditationAmounts.toList(), user.user.value.totalMinutes));
    } catch (e) {
      logError("Failed to save top percentile");
    }
    return activeUsers;
  }

  List<User> getActiveAndNewUsers(List<User> users) {
    List<User> activeUsers = getActiveUsers(users);
    DateTime now = DateTime.now();
    // TODAY in the local time zone
    DateTime today = DateTime(now.year, now.month, now.day);
    List<User> newUsers = [];
    for (User user in users) {
      if (user.createdAt.isAfter(today.subtract(const Duration(days: 3)))) {
        newUsers.add(user);
      }
    }
    for (User user in activeUsers) {
      if (newUsers.contains(user)) {
        newUsers.remove(user);
      }
    }
    return activeUsers + newUsers;
  }

  Future<List<Follow>> getFollowers(User stylist) async {
    List<Follow> _followers = List.empty();
    try {
      _followers = await api.follow.getStylistFollowers(stylist);
    } catch (e) {
      logError("Failed to get users followers: " + e.toString());
    }
    return _followers;
  }

  Future<List<Follow>> getFollowing(User stylist) async {
    List<Follow> _followers = List.empty();
    try {
      _followers = await api.follow.getStylistFollowing(stylist);
    } catch (e) {
      logError("Failed to get users following: " + e.toString());
    }
    return _followers;
  }

  Future<List<User>> getStylistNotFollowing(User stylist) async {
    List<User> _followers = List.empty();
    try {
      _followers = await api.follow.getStylistNotFollowing(stylist);
    } catch (e) {
      logError("Failed to get users not following: " + e.toString());
    }
    return _followers;
  }

  List<User> getAllUsersFollowing(User user) {
    List<User> _usersFollowing = [];
    for (Follow follow in allUserFollowers) {
      if (follow.user.id == user.id) {
        _usersFollowing.add(follow.following!);
      }
    }
    return _usersFollowing;
  }

  // TODO: this will start to slow down as the app gets more users. Need to optimize eventually
  List<User> getAllUsersFollowedBy(User user) {
    List<User> _usersFollowed = [];
    for (Follow follow in allUserFollowers) {
      if (follow.following?.id == user.id) {
        _usersFollowed.add(follow.user);
      }
    }
    return _usersFollowed;
  }

  Future<void> fetchFollows() async {
    if (allUserFollowers.isEmpty) {
      loadingFollowers.value = true;
      update();
    }
    try {
      // Fetch all the required data concurrently
      final results = await Future.wait([
        api.follow.getEveryUserFollowers(), // Fetch all followers
        api.follow.getFollowers(), // Fetch followers of the user
        api.follow.getFollowing(), // Fetch users being followed
        api.follow.getStylistNotFollowing(Get.find<UserController>()
            .user
            .value), // Fetch stylists not being followed
      ]);

      // Destructure the results into separate variables
      allUserFollowers.value = results[0] as List<Follow>;
      List<Follow> _followers = results[1] as List<Follow>;
      List<Follow> _following = results[2] as List<Follow>;
      List<User> _notFollowing = results[3] as List<User>;

      UserController userController = Get.find();
      following.value = _followers;
      followers.value = [];
      usersFollowing.value = [];
      usersNotFollowing.value = [];
      usersFollowingIDs.value = [];
      newFollowers.value = [];
      for (Follow follow in _followers) {
        if (follow.type == "Stylist") {
          followers.add(follow.user);

          // if follow was created in the last 3 days, add to newFollowers
          if (follow.createdAt!
              .isAfter(DateTime.now().subtract(const Duration(days: 3)))) {
            newFollowers.add(follow.user);
          }
        }
      }

      for (Follow follow in _following) {
        usersFollowing.add(follow.following!);
        usersFollowingIDs.add(follow.following!.id!);
      }

      for (User follow in _notFollowing) {
        if (!usersFollowingIDs.contains(follow.id)) {
          if (userController.user.value.id != follow.id) {
            usersNotFollowing.add(follow);
          }
        }
      }
    } catch (error, trace) {
      logError(error.toString());
      logError(trace.toString());
    }
    loadingFollowers.value = false;
    updateCombinedUsers();
    update();
  }

  Future<void> followStylist(User stylist) async {
    if (usersFollowingIDs.contains(stylist.id)) {
      usersFollowing.remove(stylist);
      usersFollowingIDs.remove(stylist.id);
      try {
        await api.follow.unfollowUser(stylist);
      } catch (error, trace) {
        logError("Failed to unfollow user: " + error.toString());
        logError(trace.toString());
      }
    } else {
      usersFollowing.add(stylist);
      usersFollowingIDs.add(stylist.id!);
      try {
        await api.follow.followUser(stylist);
      } catch (error, trace) {
        logError("Failed to follow user " + error.toString());
        logError(trace.toString());
      }
    }

    update();
  }
}
