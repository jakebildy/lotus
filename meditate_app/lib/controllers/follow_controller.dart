import 'package:get/get.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/models/follow.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/models/follow.dart';
import 'package:meditate_app/api/index.dart' as Api;
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/util/logger.dart';

class FollowController extends GetxController {
  RxList<User> stylistsFollowing = new RxList();
  RxList<User> stylistsNotFollowing = new RxList();
  RxList<String> sellersFollowingIDs = new RxList();
  RxList<String> stylistsFollowingIDs = new RxList();
  //Note: for now, brands are unable to follow people,
  //and thus all followers are also users. This may change in the future.
  RxList<User> followers = new RxList();
  RxList<Follow> following = new RxList();

  FollowController() {
    fetchFollows();
  }

  Future<List<Follow>> getStylistFollowers(User stylist) async {
    List<Follow> _followers = new List.empty();
    try {
      _followers = await Api.follow.getStylistFollowers(stylist);
    } catch (e) {
      logError("Failed to get users followers: " + e.toString());
    }
    return _followers;
  }

  Future<List<Follow>> getStylistFollowing(User stylist) async {
    List<Follow> _followers = new List.empty();
    try {
      _followers = await Api.follow.getStylistFollowing(stylist);
    } catch (e) {
      logError("Failed to get users following: " + e.toString());
    }
    return _followers;
  }

  Future<List<User>> getStylistNotFollowing(User stylist) async {
    List<User> _followers = new List.empty();
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
      sellersFollowingIDs.value = [];
      stylistsFollowing.value = [];
      stylistsNotFollowing.value = [];
      stylistsFollowingIDs.value = [];
      for (Follow follow in _followers) {
        if (follow.type == "Stylist") {
          followers.add(follow.user);
        }
      }

      for (Follow follow in _following) {
        stylistsFollowing.add(follow.stylist!);
        stylistsFollowingIDs.add(follow.stylist!.id!);
      }

      for (User follow in _notFollowing) {
        if (!stylistsFollowingIDs.contains(follow.id)) {
          if (auth.user.value.id != follow.id) {
            stylistsNotFollowing.add(follow);
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
    if (stylistsFollowingIDs.contains(stylist.id)) {
      stylistsFollowing.remove(stylist);
      stylistsFollowingIDs.remove(stylist.id);
      try {
        await Api.follow.unfollowUser(stylist);
      } catch (error, trace) {
        logError("Failed to unfollow user: " + error.toString());
        logError(trace.toString());
      }
    } else {
      stylistsFollowing.add(stylist);
      stylistsFollowingIDs.add(stylist.id!);
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
