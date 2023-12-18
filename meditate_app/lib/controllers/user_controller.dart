import 'package:get/get.dart';
import 'package:meditate_app/controllers/cookie_controller.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/network_status_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/search_controller.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/api/index.dart' as api;
import 'package:meditate_app/services/push_notification_service.dart';
import 'package:meditate_app/pages/signup/signup.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:meditate_app/util/turtles.dart';

User noUser = User(
  id: "-1",
  email: "...",
  fullName: "Loading User",
  username: "null",
  createdAt: DateTime.now(),
  lastMeditated: DateTime.now(),
  meditationTimesAsOf: DateTime.now(),
  meditationHistory: <DateTime, int>{}.obs,
);

/// UserController manages the current user. It handles syncing local storage
/// {@category Controllers}
class UserController extends GetxController {
  final PushNotificationService pushNotificationService = Get.find();
  final NetworkStatusController networkStatusController = Get.find();

  final Rx<User> databaseUser = noUser.obs;
  final Rx<User> localStorageUser = noUser.obs;

  Rx<User> get user =>
      networkStatusController.offline.value ? localStorageUser : databaseUser;

  /// Returns if the user is logged in or not.
  bool get isAuthenticated => user.value.id != noUser.id;

  /// Has the user done their streak today?
  RxBool hasDoneStreakToday = false.obs;

  final Rx<String> displayName = "".obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingPageNotDone = false.obs;

  @override
  void onInit() {
    super.onInit();
    loginFromCookiesRequest();

    databaseUser.listen((User user) {
      logSuccess("🔥AUTH: User value has been set ${user.username}");
      pushNotificationService.updateDeviceToken();
      Get.put(FollowController());
      Get.put(SearchController());
      updateProperty(UserProperty.streak, loadStreak());
    });
  }

  Future<void> setUser(User newUser) async {
    user.value = newUser;
    try {
      CookieController cookie = Get.find();
      await cookie.saveCookies(api.cookies);
    } catch (error, trace) {
      logError("Failed to set user " + error.toString());
      logError(trace.toString());
    }
    update();
  }

  Future<void> updateProperty(UserProperty property, dynamic value) async {
    // If the user is online, update the database - otherwise, update the local storage
    if (user == databaseUser) {
      await api.user.updateUserAttribute(property.toString(), value);
      databaseUser.value = await api.user.me();
    } else {
      User newUser = localStorageUser.value;
      // TODO: update the specific property
    }
  }

  /// Triggered when user goes offline to online
  Future<void> syncData() async {}

  int totalMinutes() {
    return 0;
  }

  /// On Success: set user, isAuthenticated to true and go to main page.
  /// On fail: user is not logged in - do nothing
  void loginFromCookiesRequest() async {
    try {
      isLoading.value = true;
      update();
      CookieController cookie = Get.find();
      String cookies = cookie.getCookies();
      api.setCookies(cookies);
      databaseUser.value = await api.user.me();
    } catch (e, stackTrace) {
      logError(e.toString());
      logError(stackTrace.toString());
    }
    waitThenSetLoadingFalse();
    update();
  }

  Future<void> waitThenSetLoadingFalse() async {
    await Future.delayed(const Duration(seconds: 4));
    isLoading.value = false;
    update();
  }

  void refreshUser() async {
    try {
      databaseUser.value = await api.user.me();
    } catch (e) {
      logError(e.toString());
    }
    update();
  }

  void logoutRequest() async {
    isLoading.value = false;
    try {
      String message = await api.auth.logout();
      logSuccess(message);
    } catch (error, trace) {
      logError(error.toString());
      logError(trace.toString());
    }
    databaseUser.value = noUser;
    localStorageUser.value = noUser;
    // isAuthenticated.value = false;
    // TODO: saveController.clearCookies();
    Get.offAll(const Signup());

    update();
  }

  int loadStreak() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    if (user.value.lastMeditated.isBefore(DateTime(2019))) {
      logInfo("last_meditated hasn't been set yet.");
      return 0;
    } else {
      int numDays = user.value.lastMeditated.difference(date).inDays.abs();

      if (numDays >= 1) {
        hasDoneStreakToday.value = false;
      }

      if (numDays <= 1) {
        if (numDays < 1) {
          hasDoneStreakToday.value = true;
          update();
        } else {
          logInfo("Parsing streak...");
        }
        return user.value.streak;
      } else {
        //If you lose your streak

        //Use a streak freeze if possible
        if (user.value.streakFreezes > 0) {
          DateTime now = DateTime.now();
          DateTime today = DateTime(now.year, now.month, now.day);
          DateTime yesterday = today.subtract(const Duration(days: 1));
          updateProperty(
              UserProperty.lastMeditated, yesterday.toIso8601String());
          updateProperty(
              UserProperty.streakFreezes, user.value.streakFreezes - 1);
          logInfo("Streak freeze has been used. Returning streak.");
          return user.value.streak;
        } else {
          return 0;
        }
      }
    }
  }

  double streakAverage() {
    // Get current date and time
    DateTime now = DateTime.now();

    // Filter and sort the last seven days
    var lastSevenDays = user.value.meditationHistory.entries
        .where(
            (entry) => entry.key.isAfter(now.subtract(const Duration(days: 7))))
        .toList();

    // Sort in descending order
    lastSevenDays.sort((a, b) => b.key.compareTo(a.key));

    // Calculate the sum
    double sum = lastSevenDays.fold(0, (prev, entry) => prev + entry.value);

    // Calculate the average
    return lastSevenDays.isNotEmpty ? sum / lastSevenDays.length : 0.0;
  }

  String streakIconURL() {
    logInfo(
        "Has the user meditated today? " + hasDoneStreakToday.value.toString());
    return hasDoneStreakToday.value
        ? streakAverage() < 10
            ? "assets/streak_icon.png"
            : streakAverage() < 20
                ? "assets/streak_icon_yellow.png"
                : streakAverage() < 40
                    ? "assets/streak_icon_blue.png"
                    : "assets/streak_icon_rainbow.png"
        : "assets/streak_icon_grey.png";
  }

  String streakIconURLBBright() {
    return streakAverage() < 10
        ? "assets/streak_icon.png"
        : streakAverage() < 20
            ? "assets/streak_icon_yellow.png"
            : streakAverage() < 40
                ? "assets/streak_icon_blue.png"
                : "assets/streak_icon_rainbow.png";
  }

  Tier streakTier() {
    return streakAverage() < 10
        ? Tier.ORANGE
        : streakAverage() < 20
            ? Tier.YELLOW
            : streakAverage() < 40
                ? Tier.BLUE
                : Tier.RAINBOW;
  }

  void updateStreak(int newValue) {
    hasDoneStreakToday.value = true;
    updateProperty(UserProperty.streak, newValue);
    update();
  }

  void logMeditation(int amountNew, DateTime date) {
    logInfo("Saving last_meditated to ${date.toIso8601String()}");
    updateProperty(UserProperty.lastMeditated, date);
    // saveController.saveValue("last_meditated", date.toIso8601String());

    updateProperty(
        UserProperty.totalMinutes, user.value.totalMinutes + amountNew);
    // saveValue("total_minutes", newValue.toString());
    // // totalMinutes.value = newValue;

    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);

    // Check if today exists in meditationHistory
    if (user.value.meditationHistory[today] != null) {
      updateProperty(UserProperty.meditationHistory, {
        today: user.value.meditationHistory[today]! + amountNew,
        ...user.value.meditationHistory
      });
      logInfo(
          "Updating meditationHistory for today! There was already a value here but the new meditation amount has been appended.");
    } else {
      updateProperty(UserProperty.meditationHistory,
          {today: amountNew, ...user.value.meditationHistory});
      logInfo(
          "Updating meditationHistory for today! First time meditating for today, so a new key/value was added.");
    }
    update();

    // if (getValue('meditation-${today.day}-${today.month}-${today.year}') ==
    //     "") {
    //   saveValue('meditation-${today.day}-${today.month}-${today.year}',
    //       amountNew.toString());
    // } else {
    //   saveValue(
    //       'meditation-${today.day}-${today.month}-${today.year}',
    //       (double.parse(getValue(
    //                   'meditation-${today.day}-${today.month}-${today.year}')) +
    //               amountNew)
    //           .toString());
    // }

    // lastSevenDays[0] += amountNew;

    // DateTime simpleDate = new DateTime(today.year, today.month, today.day);
    // if (meditationHistory[simpleDate] != null) {
    //   int oldValue = meditationHistory.remove(simpleDate) ?? 0;
    //   meditationHistory.addAll({simpleDate: oldValue + amountNew});
    //   logInfo(
    //       "Updating meditationHistory for today! There was already a value here but the new meditation amount has been appended.");
    // } else {
    //   meditationHistory.addAll({simpleDate: amountNew});
    //   logInfo(
    //       "Updating meditationHistory for today! First time meditating for today, so a new key/value was added.");
    // }
    // meditationHistory.refresh();
    // update();
  }
}
