import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meditate_app/controllers/cookie_controller.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/network_status_controller.dart';
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
  createdAt: DateTime.parse("2011-10-05T14:48:00.000Z"),
  updatedAt: DateTime.parse("2011-10-05T14:48:00.000Z"),
  lastMeditated: DateTime.now(),
  meditationTimesAsOf: DateTime.now(),
  meditationHistory: <DateTime, int>{}.obs,
);

/// UserController manages the current user. It handles syncing local storage
/// {@category Controllers}
class UserController extends GetxController {
  final PushNotificationService pushNotificationService = Get.find();
  final NetworkStatusController networkStatusController = Get.find();
  final storage = GetStorage();

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

  bool loadedStreak = false;

  @override
  void onInit() {
    super.onInit();
    loginFromCookiesRequest();

    databaseUser.listen((User user) {
      logSuccess("🔥AUTH: User value has been set ${user.username}");
      pushNotificationService.updateDeviceToken();
      Get.put(FollowController());
      Get.put(SearchController());
      if (!loadedStreak) {
        loadedStreak = true;
        updateProperty(UserProperty.streak, loadStreak());
      }
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

  /// This saves the changed value to the local storage. Also updates the localStorageUser and lastUpdatedAt - this is used to sync data when the user goes online.
  Future<void> saveLocalValue(UserProperty key, dynamic value) async {
    //TODO: confirm on values. Then use old phone and print
    switch (key) {
      case UserProperty.streak: //Completed
        storage.write("streak", value.toString());
        localStorageUser.value.streak = value as int;
        break;
      case UserProperty.totalMinutes: //Completed
        storage.write("total_minutes", value.toString());
        localStorageUser.value.totalMinutes = int.parse(value);
        break;
      case UserProperty.streakFreezes:
        storage.write("streak_freezes", value.toString());
        localStorageUser.value.streakFreezes = value as int;
        break;
      // case "unlocked_turtle_colors":
      //   localStorageUser.value.unlockedTurtleColors = value.split(",").map((e) {
      //     return e.split(":").map((e) {
      //       return int.parse(e);
      //     }).toList();
      //   }).toList();
      //   break;
      case UserProperty.unlockedTurtles:
        //'turtle-${turtle.name}'
        localStorageUser.value.unlockedTurtles = value.split(",").map((e) {
          return int.parse(e);
        }).toList();
        break;
      case UserProperty.lastMeditated: //Completed
        storage.write("last_meditated", value);
        localStorageUser.value.lastMeditated = DateTime.parse(value);
        break;
      // case "meditation_history": //'meditation-${today.day}-${today.month}-${today.year}' check back to 2020
      //   // localStorageUser.value.meditationHistory = {}; TODO: fix this
      //   value.split(",").forEach((element) {
      //     List<String> split = element.split(":");
      //     localStorageUser.value.meditationHistory[DateTime.parse(split[0])] =
      //         int.parse(split[1]);
      //   });
      //   break;
      default:
        logError("Unknown key: $key");
    }

    storage.write(
        "LAST_UPDATED_AT",
        DateTime.now()
            .toIso8601String()); //TODO: just for save local value only? or is this correct
  }

  /// This gets the local storage value.
  String getValue(String key) {
    return storage.read(key) ?? "";
  }

  /// This function loads the localStorageUser.
  Future<void> getLocalStorageUser() async {
    logInfo("Getting Local Storage User");
    if (getValue('streak') != "") {
      localStorageUser.value.streak = int.parse(getValue("streak"));
      logSuccess("Loaded streak: ${localStorageUser.value.streak}");
    }

    if (getValue('total_minutes') != "") {
      localStorageUser.value.totalMinutes =
          int.parse(getValue("total_minutes"));
      logSuccess("Loaded totalMinutes: ${localStorageUser.value.totalMinutes}");
    }

    if (getValue('gems') != "") {
      localStorageUser.value.gems = int.parse(getValue("gems"));
      logSuccess("Loaded gems: ${localStorageUser.value.gems}");
    }

    if (getValue('streak_freezes') != "") {
      localStorageUser.value.streakFreezes =
          int.parse(getValue("streak_freezes"));
      logSuccess(
          "Loaded streakFreezes: ${localStorageUser.value.streakFreezes}");
    }

    if (getValue('last_meditated') != "") {
      localStorageUser.value.lastMeditated =
          DateTime.parse(getValue("last_meditated"));
      logSuccess(
          "Loaded lastMeditated: ${localStorageUser.value.lastMeditated}");
    }

    if (getValue('egg_progress_one') != "") {
      localStorageUser.value.hatchProgressEggOne =
          int.parse(getValue("egg_progress_one"));
      logSuccess(
          "Loaded hatchProgressEggOne: ${localStorageUser.value.hatchProgressEggOne}");
    }

    if (getValue('eggs') != "") {
      localStorageUser.value.eggs = int.parse(getValue("eggs"));
      logSuccess("Loaded eggs: ${localStorageUser.value.eggs}");
    }

    if (getValue('total_eggs') != "") {
      localStorageUser.value.totalEggs = int.parse(getValue("total_eggs"));
      logSuccess("Loaded total eggs: ${localStorageUser.value.totalEggs}");
    }

    if (getValue('egg_types') != "") {
      List<String> eggTypesValue =
          getValue('egg_types').replaceAll(" ", "").split(",");
      localStorageUser.value.eggTypes = RxList.empty();
      for (String type in eggTypesValue) {
        localStorageUser.value.eggTypes.add(type);
      }
      logSuccess("Loaded eggTypes: ${localStorageUser.value.eggTypes}");
    } else {
      logWarning("No eggTypes found in local storage.");
    }

    // Load unlocked turtle data
    for (int i = 0; i < TURTLES.length; i++) {
      if (getValue('turtle-$i') != "") {
        localStorageUser.value.unlockedTurtles =
            List<int>.from(localStorageUser.value.unlockedTurtles)
              ..add(int.parse(getValue('turtle-$i')));

        if (getValue('turtle-$i-color') != "") {
          localStorageUser.value.unlockedTurtleColors = List<List<int>>.from(
              localStorageUser.value.unlockedTurtleColors)
            ..add(
                getValue('turtle-$i-color').split(',').map(int.parse).toList());

          // localStorageUser.value.unlockedTurtleColors.add(
          //     getValue('turtle-$i-color').split(',').map(int.parse).toList());
          // localStorageUser.value.unlockedTurtleColors[i].add(-1);
        } else {
          logError("No turtle color found for turtle $i");
        }
      } else {
        localStorageUser.value.unlockedTurtles =
            List<int>.from(localStorageUser.value.unlockedTurtles)..add(0);

        localStorageUser.value.unlockedTurtleColors.add([-1]);
      }
    }
    logSuccess(
        "Loaded unlocked turtles: ${localStorageUser.value.unlockedTurtles}");
    logSuccess(
        "Loaded unlocked turtle colors: ${localStorageUser.value.unlockedTurtleColors}");

    // Load the entire meditation history for the past year
    // If gems does not exist, neither does meditation history yet
    if (getValue('gems') != "") {
      DateTime rn = DateTime.now();
      DateTime today = DateTime.now();
      while (rn.difference(today).abs().inDays <= 365) {
        DateTime simpleDate = DateTime(today.year, today.month, today.day);
        localStorageUser
            .value.meditationHistory[simpleDate] = (double.tryParse(getValue(
                    'meditation-${today.day}-${today.month}-${today.year}')) ??
                0.0)
            .round();
        today = today.subtract(const Duration(days: 1));
      }
    }
    logSuccess(
        "Loaded meditation history with length: ${localStorageUser.value.meditationHistory.length}");
  }

  Future<void> updateProperty(UserProperty property, dynamic value) async {
    // If the user is online, update the database - otherwise, update the local storage
    if (user == databaseUser) {
      if (property == UserProperty.emojisSentAt) {
        value =
            value.map((key, value) => MapEntry(key, value.toIso8601String()));
      } else if (property == UserProperty.meditationHistory) {
        value = value.map((key, value) =>
            MapEntry('meditation-${key.day}-${key.month}-${key.year}', value));
      }

      logSuccess(
          "UPDATING PROPERTY=> " + property.name + ":" + value.toString());
      await api.user.updateUserAttribute(property.name, value);
      databaseUser.value = await api.user.me();
      update();
    }
    //saveLocalValue(property, value); TODO: uncomment once getLocalStorageUser verified
  }

  Future<void> syncDatabasetoMatchLocalStorage() async {
    databaseUser.value = localStorageUser.value;
    updateProperty(UserProperty.streak, localStorageUser.value.streak);
    updateProperty(
        UserProperty.totalMinutes, localStorageUser.value.totalMinutes);
    updateProperty(
        UserProperty.streakFreezes, localStorageUser.value.streakFreezes);
    updateProperty(UserProperty.lastMeditated,
        localStorageUser.value.lastMeditated.toIso8601String());
    updateProperty(UserProperty.meditationHistory,
        localStorageUser.value.meditationHistory);
    updateProperty(UserProperty.eggs, localStorageUser.value.eggs);
    updateProperty(UserProperty.totalEggs, localStorageUser.value.totalEggs);
    updateProperty(UserProperty.eggTypes, localStorageUser.value.eggTypes);
    updateProperty(
        UserProperty.unlockedTurtles, localStorageUser.value.unlockedTurtles);
    updateProperty(UserProperty.unlockedTurtleColors,
        localStorageUser.value.unlockedTurtleColors);
  }

  Future<void> syncLocalStorageToMatchDatabase() async {
    // TODO:
  }

  /// Triggered when user goes offline to online
  Future<void> syncData() async {
    await getLocalStorageUser();

    if (databaseUser.value.id == "-1") {
      logWarning("Not Syncing Data - database user has not been returned");
    } else {
      logWarning("Syncing Data!");

      // If no lastUpdatedAt in localStorage, add it, and sync databaseUser to match localStorageUser -
      //this is the edge case when the user UPDATES the app
      if (getValue("LAST_UPDATED_AT") == "") {
        logInfo("No lastUpdatedAt in localStorage. Adding it now.");
        storage.write("LAST_UPDATED_AT", DateTime.now().toIso8601String());

        syncDatabasetoMatchLocalStorage();
      } else {
        // If lastUpdatedAt in localStorage, compare it to databaseUser's lastUpdatedAt
        DateTime lastUpdatedAtLocalStorage =
            DateTime.parse(getValue("LAST_UPDATED_AT"));
        DateTime lastUpdatedAtDatabase = databaseUser.value.updatedAt; //TODO:

        // If lastUpdatedAt in localStorage is more recent, sync databaseUser to match localStorageUser
        if (lastUpdatedAtLocalStorage.isAfter(lastUpdatedAtDatabase)) {
          logWarning(
              "localStorage is more recent. Syncing databaseUser to match localStorageUser. Last updated local storage: " +
                  lastUpdatedAtLocalStorage.toIso8601String() +
                  " vs " +
                  lastUpdatedAtDatabase.toIso8601String() +
                  " in the database");
          syncDatabasetoMatchLocalStorage();
        } else {
          // If lastUpdatedAt in database is more recent, sync localStorageUser to match databaseUser
          logWarning(
              "databaseUser is more recent. Syncing localStorageUser to match databaseUser. Last updated local storage: " +
                  lastUpdatedAtLocalStorage.toIso8601String() +
                  " vs " +
                  lastUpdatedAtDatabase.toIso8601String() +
                  " in the database");
          syncLocalStorageToMatchDatabase();
        }
      }
      update();
    }
  }

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
    loadedStreak = false;
    try {
      String message = await api.auth.logout();
      logSuccess(message);
    } catch (error, trace) {
      logError(error.toString());
      logError(trace.toString());
    }
    databaseUser.value = noUser;
    localStorageUser.value = noUser;

    CookieController cookie = Get.find();
    cookie.clearCookies();
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
    return lastSevenDays.isNotEmpty ? sum / 7 : 0.0;
  }

  String streakIconURL() {
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
    updateProperty(UserProperty.lastMeditated, date.toIso8601String());
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
        ...user.value.meditationHistory,
        today: user.value.meditationHistory[today]! + amountNew,
      });
      logInfo(
          "Updating meditationHistory for today! There was already a value here but the new meditation amount has been appended.");
    } else {
      updateProperty(UserProperty.meditationHistory,
          {...user.value.meditationHistory, today: amountNew});
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
