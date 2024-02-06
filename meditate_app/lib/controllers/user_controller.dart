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

  void updateLoadingPage(bool value) {
    isLoadingPageNotDone.value = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loginFromCookiesRequest();

    databaseUser.listen((User user) {
      logSuccess("🔥AUTH: User value has been set ${user.username}");
      pushNotificationService.updateDeviceToken();
      Get.put(FollowController());
      Get.put(SearchController());
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
  Future<void> saveLocalValue(
    UserProperty key,
    dynamic value,
  ) async {
    switch (key) {
      case UserProperty.streak: //Completed
        storage.write("streak", value.toString());

        logWarning(
            "streak storage value: " + storage.read("streak").toString());
        logInfo("streak: " + value.toString());
        localStorageUser.value.streak = value as int;
        break;
      case UserProperty.gems: //Completed
        storage.write("gems", value.toString());

        logWarning("gems storage value: " + storage.read("gems").toString());
        logInfo("gems: " + value.toString());
        localStorageUser.value.gems = value as int;
        break;
      case UserProperty.hatchProgressEggOne: //Completed
        storage.write("egg_progress_one", value.toString());

        logWarning("egg_progress_one storage value: " +
            storage.read("egg_progress_one"));
        logInfo("egg_progress_one: " + value.toString());
        localStorageUser.value.hatchProgressEggOne = value as int;
        break;

      case UserProperty.eggs: //Completed
        storage.write("eggs", value.toString());

        logWarning("eggs storage value: " + storage.read("eggs").toString());
        logInfo("eggs: " + value.toString());
        localStorageUser.value.eggs = value as int;
        break;
      case UserProperty.totalEggs: //Completed
        storage.write("total_eggs", value.toString());

        logWarning("total_eggs storage value: " +
            storage.read("total_eggs").toString());
        logInfo("total_eggs: " + value.toString());
        localStorageUser.value.totalEggs = value as int;
        break;
      case UserProperty.totalMinutes: //Completed
        storage.write("total_minutes", value.toString());

        logWarning(
            "total_minutes storage value: " + storage.read("total_minutes"));
        logInfo("total_minutes: " + value.toString());
        localStorageUser.value.totalMinutes = value as int;
        break;
      case UserProperty.streakFreezes:
        storage.write("streak_freezes", value.toString());

        logWarning(
            "streak_freezes storage value: " + storage.read("streak_freezes"));
        logInfo("streak_freezes: " + value.toString());
        localStorageUser.value.streakFreezes = value as int;
        break;
      case UserProperty.unlockedTurtleColors:
        localStorageUser.value.unlockedTurtleColors = value;
        for (int i = 0; i < TURTLES.length; i++) {
          logWarning("turtle-$i-color storage value: " +
              localStorageUser.value.unlockedTurtleColors[i]
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", ""));
          storage.write(
              "turtle-$i-color",
              localStorageUser.value.unlockedTurtleColors[i]
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", ""));
        }

        break;
      case UserProperty.unlockedTurtles:
        localStorageUser.value.unlockedTurtles = value;
        for (int i = 0; i < TURTLES.length; i++) {
          logWarning("turtle-$i: " + storage.read("turtle-$i").toString());

          logWarning("turtle-$i storage value: " +
              localStorageUser.value.unlockedTurtles[i].toString());

          storage.write("turtle-$i",
              localStorageUser.value.unlockedTurtles[i].toString());
        }

        break;
      case UserProperty.lastMeditated: //Completed
        storage.write("last_meditated", value);

        logWarning("last_meditated storage value: " +
            storage.read("last_meditated").toString());
        logInfo("last_meditated: " + value.toString());
        localStorageUser.value.lastMeditated = DateTime.parse(value);
        break;
      case UserProperty.eggTypes:
        logWarning(
            "egg_types storage value: " + storage.read("egg_types").toString());
        // Convert List<String> to a comma-separated string to store
        String eggTypesString =
            value.join(",").replaceAll("[", "").replaceAll("]", "");
        logInfo("egg_types: " + eggTypesString);
        storage.write("egg_types", eggTypesString);
        localStorageUser.value.eggTypes = RxList<String>.from(value);
        break;
      case UserProperty.meditationHistory:
        logWarning("meditation_history storage value: " +
            (storage.read("meditation_history") ?? ""));
        // logError("MEDITATION HISTORY saveLocalValue");
        // logError(value.toString());

        // If its still a datetime, convert to string
        if (value is Map<DateTime, int>) {
          Map<String, int> newValue = value.map((key, value) => MapEntry(
              'meditation-${key.day}-${key.month}-${key.year}', value));
          value = newValue;
        }
        for (String key in value.keys) {
          // logInfo("Saving meditation history: $key:" + value[key].toString());
          storage.write(key, value[key].toString());
        }
        localStorageUser.value.meditationHistory = RxMap<DateTime, int>.from(
            (value as Map<String, int>).map((key, value) => MapEntry(
                DateTime(int.parse(key.split("-")[3]),
                    int.parse(key.split("-")[2]), int.parse(key.split("-")[1])),
                value)));
        break;

      default:
        logError("Unknown key: $key");
    }

    logSuccess("Setting LAST_UPDATED_AT: " +
        DateTime.now().toUtc().toIso8601String() +
        " (UTC)");
    storage.write("LAST_UPDATED_AT", DateTime.now().toUtc().toIso8601String());

    logSuccess(
        "UPDATING LOCAL STORAGE => " + key.name + ":" + value.toString());
  }

  /// This gets the local storage value.
  String getValue(String key) {
    // check if it's an int, if so, convert to string
    if (storage.read(key) is int) {
      return (storage.read(key) as int).toString();
    }
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

        localStorageUser.value.unlockedTurtleColors =
            List<List<int>>.from(localStorageUser.value.unlockedTurtleColors)
              ..add([-1]);
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

    update();
  }

  Future<void> updateProperty(UserProperty property, dynamic value) async {
    // If the user is online, update the database - regardless, update the local storage

    switch (property) {
      case UserProperty.emojisSentAt:
        value =
            value.map((key, value) => MapEntry(key, value.toIso8601String()));
        break;
      case UserProperty.meditationHistory:
        value = value.map((key, value) =>
            MapEntry('meditation-${key.day}-${key.month}-${key.year}', value));

        logError("THIS IS WHAT WE SEE:");
        logError(value.toString());
        break;

      case UserProperty.unlockedTurtleColors:
        logWarning("updating DATABASE: " + value.toString());
        break;

      case UserProperty.unlockedTurtles:
        logWarning("updating DATABASE: " + value.toString());
        break;

      default:
        break;
    }

    switch (property) {
      case UserProperty.streak:
        databaseUser.value.streak = value as int;
        break;
      case UserProperty.gems:
        databaseUser.value.gems = value as int;
        break;
      case UserProperty.hatchProgressEggOne:
        databaseUser.value.hatchProgressEggOne = value as int;
        break;
      case UserProperty.eggs:
        databaseUser.value.eggs = value as int;
        break;
      case UserProperty.totalEggs:
        databaseUser.value.totalEggs = value as int;
        break;
      case UserProperty.totalMinutes:
        databaseUser.value.totalMinutes = value as int;
        break;
      case UserProperty.streakFreezes:
        databaseUser.value.streakFreezes = value as int;
        break;
      case UserProperty.unlockedTurtleColors:
        databaseUser.value.unlockedTurtleColors = value;
        break;
      case UserProperty.unlockedTurtles:
        databaseUser.value.unlockedTurtles = value;
        break;
      case UserProperty.lastMeditated:
        databaseUser.value.lastMeditated = DateTime.parse(value);
        break;
      case UserProperty.eggTypes:
        databaseUser.value.eggTypes = RxList<String>.from(value);
        break;
      case UserProperty.meditationHistory:
        // Not doing anything here right now
        break;
      default:
        logError("Unknown key: $value");
    }
    update();

    if (!networkStatusController.offline.value) {
      logSuccess(
          "UPDATING DATABASE => " + property.name + ":" + value.toString());
      try {
        await api.user.updateUserAttribute(property.name, value);
        databaseUser.value = await api.user.me();
      } catch (e) {
        logError("Failed to update database");
      }
    }
    saveLocalValue(property, value);
    update();
  }

  Future<void> syncDatabasetoMatchLocalStorage() async {
    logInfo("Starting syncDatabaseToMatchLocalStorage...");
    databaseUser.value = localStorageUser.value;

    // Collecting all update operations in a list of Futures
    var updateOperations = [
      updatePropertySafe(UserProperty.streak, localStorageUser.value.streak),
      updatePropertySafe(UserProperty.gems, localStorageUser.value.gems),
      updatePropertySafe(
          UserProperty.totalMinutes, localStorageUser.value.totalMinutes),
      updatePropertySafe(
          UserProperty.streakFreezes, localStorageUser.value.streakFreezes),
      updatePropertySafe(UserProperty.lastMeditated,
          localStorageUser.value.lastMeditated.toIso8601String()),
      updatePropertySafe(UserProperty.meditationHistory,
          localStorageUser.value.meditationHistory),
      updatePropertySafe(UserProperty.eggs, localStorageUser.value.eggs),
      updatePropertySafe(
          UserProperty.totalEggs, localStorageUser.value.totalEggs),
      updatePropertySafe(
          UserProperty.eggTypes, localStorageUser.value.eggTypes),
      updatePropertySafe(
          UserProperty.unlockedTurtles, localStorageUser.value.unlockedTurtles),
      updatePropertySafe(UserProperty.unlockedTurtleColors,
          localStorageUser.value.unlockedTurtleColors),
    ];

    // Waiting for all update operations to complete
    await Future.wait(updateOperations);

    logInfo("Completed syncDatabasetoMatchLocalStorage");
  }

// Helper function to perform update operations safely and log errors
  Future<void> updatePropertySafe(UserProperty property, dynamic value) async {
    try {
      await updateProperty(property, value);
    } catch (e) {
      logError("Failed to update ${property.toString()}: $e");
    }
  }

  Future<void> syncLocalStorageToMatchDatabase() async {
    logInfo("Starting syncLocalStorageToMatchDatabase...");

    var saveOperations = [
      saveLocalValueSafe(UserProperty.streak, databaseUser.value.streak),
      saveLocalValueSafe(UserProperty.gems, databaseUser.value.gems),
      saveLocalValueSafe(
          UserProperty.totalMinutes, databaseUser.value.totalMinutes),
      saveLocalValueSafe(
          UserProperty.streakFreezes, databaseUser.value.streakFreezes),
      saveLocalValueSafe(UserProperty.lastMeditated,
          databaseUser.value.lastMeditated.toIso8601String()),
      saveLocalValueSafe(
          UserProperty.meditationHistory, databaseUser.value.meditationHistory),
      saveLocalValueSafe(UserProperty.eggs, databaseUser.value.eggs),
      saveLocalValueSafe(UserProperty.totalEggs, databaseUser.value.totalEggs),
      saveLocalValueSafe(UserProperty.eggTypes, databaseUser.value.eggTypes),
      saveLocalValueSafe(
          UserProperty.unlockedTurtles, databaseUser.value.unlockedTurtles),
      saveLocalValueSafe(UserProperty.unlockedTurtleColors,
          databaseUser.value.unlockedTurtleColors),
    ];

    // Waiting for all save operations to complete
    await Future.wait(saveOperations);

    logInfo("Completed syncLocalStorageToMatchDatabase");
  }

// Helper function for save operations with error handling
  Future<void> saveLocalValueSafe(UserProperty property, dynamic value) async {
    try {
      await saveLocalValue(property, value);
    } catch (e) {
      logError("Failed to save ${property.toString()}: $e");
    }
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
        storage.write(
            "LAST_UPDATED_AT", DateTime.now().toUtc().toIso8601String());

        await syncDatabasetoMatchLocalStorage();
      } else {
        // If lastUpdatedAt in localStorage, compare it to databaseUser's lastUpdatedAt
        DateTime lastUpdatedAtLocalStorage =
            DateTime.parse(getValue("LAST_UPDATED_AT"));
        DateTime lastUpdatedAtDatabase = databaseUser.value.updatedAt;

        // If lastUpdatedAt in localStorage is more recent, sync databaseUser to match localStorageUser
        if (lastUpdatedAtLocalStorage.isAfter(lastUpdatedAtDatabase)) {
          logWarning(
              "localStorage is more recent. Syncing databaseUser to match localStorageUser. Last updated local storage: " +
                  lastUpdatedAtLocalStorage.toIso8601String() +
                  " vs " +
                  lastUpdatedAtDatabase.toIso8601String() +
                  " in the database");
          await syncDatabasetoMatchLocalStorage();
        } else {
          // If lastUpdatedAt in database is more recent, sync localStorageUser to match databaseUser
          logWarning(
              "databaseUser is more recent. Syncing localStorageUser to match databaseUser. Last updated local storage: " +
                  lastUpdatedAtLocalStorage.toIso8601String() +
                  " vs " +
                  lastUpdatedAtDatabase.toIso8601String() +
                  " in the database");
          await syncLocalStorageToMatchDatabase();
        }
      }
      update();
    }
  }

  /// On Success: set user, isAuthenticated to true and go to main page.
  /// On fail: user is not logged in - do nothing
  Future<void> loginFromCookiesRequest() async {
    try {
      isLoading.value = true;
      update();
      CookieController cookie = Get.find();
      String cookies = cookie.getCookies();
      api.setCookies(cookies);
      databaseUser.value = await api.user.me();
      // await syncData();
    } catch (e, stackTrace) {
      logError(e.toString());
      logError(stackTrace.toString());
    }
    waitThenSetLoadingFalse();
    update();
  }

  Future<void> waitThenSetLoadingFalse() async {
    await Future.delayed(const Duration(seconds: 3));
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

  void loadStreak() {
    logSuccess("Loading Streak, currently " + user.value.streak.toString());
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    if (user.value.lastMeditated.isBefore(DateTime(2019))) {
      logInfo("last_meditated hasn't been set yet.");
      updateProperty(UserProperty.streak, 0);
    } else {
      int numDays = user.value.lastMeditated.difference(date).inDays.abs();

      if (numDays >= 1) {
        hasDoneStreakToday.value = false;
      }

      if (numDays <= 1) {
        if (numDays < 1) {
          hasDoneStreakToday.value = true;
          update();
        }
        //Don't change the streak value
        logSuccess("Not changing the streak value.");
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
          logSuccess("Streak freeze has been used. Returning streak.");
          updateProperty(UserProperty.streak, user.value.streak);
        } else {
          logSuccess("Lost streak! Setting to 0.");
          updateProperty(UserProperty.streak, 0);
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
    today = DateTime.utc(today.year, today.month, today.day);

    //TODO: additional meditations per day are not logging

    // Check if today exists in meditationHistory
    logError("THIS ->");
    logError(today.toIso8601String());
    logError(user.value.meditationHistory.toString());
    if (user.value.meditationHistory[today] != null) {
      logError("this was not null");
      logError(user.value.meditationHistory[today].toString());
      updateProperty(UserProperty.meditationHistory, {
        ...user.value.meditationHistory,
        today: user.value.meditationHistory[today]! + amountNew,
      });
      logInfo(
          "Updating meditationHistory for today! There was already a value here but the new meditation amount has been appended.");
    } else {
      logError("this was null!!");
      logError(user.value.meditationHistory[today].toString());
      updateProperty(UserProperty.meditationHistory,
          {...user.value.meditationHistory, today: amountNew});
      logInfo(
          "Updating meditationHistory for today! First time meditating for today, so a new key/value was added.");
    }
    update();
  }
}
