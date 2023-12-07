import 'package:get/get.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/models/follow.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/models/follow.dart';
import 'package:meditate_app/api/index.dart' as Api;
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/util/logger.dart';

/// FollowController handles following and unfollowing other users. Still have a bit of refactoring left to do.
/// {@category Controllers}
class FollowController extends GetxController {
  RxList<User> usersFollowing = RxList();
  RxList<User> usersNotFollowing = RxList();
  RxList<String> usersFollowingIDs = RxList();
  RxList<User> followers = RxList();
  RxList<Follow> following = RxList();

  FollowController() {
    fetchFollows();
  }

  Future<List<Follow>> getStylistFollowers(User stylist) async {
    List<Follow> _followers = List.empty();
    try {
      _followers = await Api.follow.getStylistFollowers(stylist);
    } catch (e) {
      logError("Failed to get users followers: " + e.toString());
    }
    return _followers;
  }

  Future<List<Follow>> getStylistFollowing(User stylist) async {
    List<Follow> _followers = List.empty();
    try {
      _followers = await Api.follow.getStylistFollowing(stylist);
    } catch (e) {
      logError("Failed to get users following: " + e.toString());
    }
    return _followers;
  }

  Future<List<User>> getStylistNotFollowing(User stylist) async {
    List<User> _followers = List.empty();
    try {
      _followers = await Api.follow.getStylistNotFollowing(stylist);
    } catch (e) {
      logError("Failed to get users not following: " + e.toString());
    }
    return _followers;
  }

  Future<void> fetchFollows() async {
    try {
      List<Follow> _followers = await Api.follow.getFollowers();
      List<Follow> _following = await Api.follow.getFollowing();
      AuthController auth = Get.find();
      List<User> _notFollowing =
          await Api.follow.getStylistNotFollowing(auth.user.value);
      following.value = _followers;
      followers.value = [];
      usersFollowing.value = [];
      usersNotFollowing.value = [];
      usersFollowingIDs.value = [];
      for (Follow follow in _followers) {
        if (follow.type == "Stylist") {
          followers.add(follow.user);
        }
      }

      for (Follow follow in _following) {
        usersFollowing.add(follow.stylist!);
        usersFollowingIDs.add(follow.stylist!.id!);
      }

      for (User follow in _notFollowing) {
        if (!usersFollowingIDs.contains(follow.id)) {
          if (auth.user.value.id != follow.id) {
            usersNotFollowing.add(follow);
          }
        }
      }
    } catch (error, trace) {
      logError(error.toString());
      logError(trace.toString());
    }
    update();
  }

  Future<void> followStylist(User stylist) async {
    if (usersFollowingIDs.contains(stylist.id)) {
      usersFollowing.remove(stylist);
      usersFollowingIDs.remove(stylist.id);
      try {
        await Api.follow.unfollowUser(stylist);
      } catch (error, trace) {
        logError("Failed to unfollow user: " + error.toString());
        logError(trace.toString());
      }
    } else {
      usersFollowing.add(stylist);
      usersFollowingIDs.add(stylist.id!);
      try {
        await Api.follow.followUser(stylist);
      } catch (error, trace) {
        logError("Failed to follow user " + error.toString());
        logError(trace.toString());
      }
    }

    update();
  }
}
