import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/api/index.dart' as Api;
import 'package:ocarina/ocarina.dart';

import '../models/user.dart';

/// SaveController is going to be deprecated
/// {@category Controllers}
class SaveController extends GetxController {
  final storage = GetStorage();

  //The User's Current Streak
  RxInt streak = 0.obs;

  //The User's Total Meditation Minutes
  RxInt totalMinutes = 0.obs;

  //The User's Total Gems
  RxInt gems = 0.obs;

  //The number of eggs the user currently has
  RxInt eggs = 0.obs;

  //The total number of eggs the user has ever collected
  RxInt totalEggs = 0.obs;

  //The type of egg the user is currently hatching (?)
  RxList eggType = new RxList(); //"3-3,2-5,etc"

  //The progress of the current egg hatching (goes from 0 to 3 (?))
  RxInt hatchProgressEggOne = 0.obs;

  //Boolean: Has the user meditaed today?
  RxBool hasDoneStreakToday = false.obs;

  //An array of the amount of time the user has meditated in the last 7 days
  RxList lastSevenDays = new RxList();

  //The number of streak freezes the user has
  RxInt streakFreezes = 0.obs;

  //The list of unlocked turtles
  RxList unlockedTurtles = RxList();

  //The list of unlocked turtle colors
  RxList unlockedTurtleColors = RxList<List<int>>();

  //Saved Settings
  RxInt defaultMeditationTime = 5.obs;
  RxBool ambienceOn = true.obs;

  //A map of the user's meditation history, with the date as the key and the amount meditated in minutes as the value
  RxMap<DateTime, int> meditationHistory = RxMap();

  void updateAmbience() {
    ambienceOn.value = !ambienceOn.value;
    saveValue("ambience_on", ambienceOn.value.toString());
    update();
  }

  void updateFetchedData(User user) {
    meditationHistory.value = user.meditationHistory;
    gems.value = user.gems;
    unlockedTurtles.value = user.unlockedTurtles;
    unlockedTurtleColors.value = user.unlockedTurtleColors;
    meditationHistory.refresh();
    update();
  }

  void updateDefaultMeditationTime(int newVal) {
    defaultMeditationTime.value = newVal;
    saveValue(
        "default_meditation_time", defaultMeditationTime.value.toString());
    update();
  }

  double streakAverage() {
    double sum = 0;
    for (double i in lastSevenDays) {
      sum += i;
    }
    return sum / 7;
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

  SaveController() {
    loadData();
    //Add the default brown swamp turtle: note, currently disabled
    // unlockedTurtles[0] += 1;
    // unlockedTurtleColors[0].add(0);
  }
  Future<void> uploadLocalData() async {
    // Upload simple attributes
    await Api.user.updateUserAttribute("streak", streak.value);
    await Api.user.updateUserAttribute("totalMinutes", totalMinutes.value);
    await Api.user.updateUserAttribute("gems", gems.value);
    await Api.user.updateUserAttribute("totalEggs", totalEggs.value);
    await Api.user
        .updateUserAttribute("hatchProgressEggOne", hatchProgressEggOne.value);

    // Upload last meditated date
    String lastMeditated = getValue("last_meditated");
    if (lastMeditated != "") {
      await Api.user.updateUserAttribute("lastMeditated", lastMeditated);
    }

    // Upload meditation times for the past week
    List<double> meditationTimes = [];
    DateTime today = DateTime.now();
    DateTime date = DateTime(today.year, today.month, today.day);
    for (int i = 0; i < 7; i++) {
      String key = 'meditation-${today.day}-${today.month}-${today.year}';
      String value = getValue(key);
      meditationTimes.add(value != "" ? double.parse(value) : 0.0);
      today = today.subtract(Duration(days: 1));
    }
    await Api.user.updateUserAttribute("meditationTimes", meditationTimes);
    await Api.user
        .updateUserAttribute("meditationTimesAsOf", date.toIso8601String());

    // Upload unlocked turtles by their names
    List<String> unlockedTurtlesNames = [];
    for (Turtle turtle in TURTLES) {
      String turtleKey = 'turtle-${turtle.name}';
      String turtleValue = getValue(turtleKey);
      if (turtleValue != "") {
        unlockedTurtlesNames.add(turtle.name);
      }
    }
    await Api.user.updateUserAttribute("unlockedTurtles", unlockedTurtlesNames);

    // Upload unlocked turtle colors
    List<List<int>> unlockedTurtleColors = [];
    for (Turtle turtle in TURTLES) {
      String turtleColorKey = 'turtle-${turtle.name}-color';
      String turtleColorValue = getValue(turtleColorKey);
      if (turtleColorValue != "") {
        List<int> colors = turtleColorValue
            .split(',')
            .map((color) => int.parse(color.trim()))
            .toList();
        unlockedTurtleColors.add(colors);
      }
    }
    await Api.user
        .updateUserAttribute("unlockedTurtleColors", unlockedTurtleColors);

    // Upload the entire meditation history for the past year
    if (lastMeditated != "") {
      Map<String, int> meditationHistory = {};
      today = DateTime.now(); // reset today to current date
      DateTime aYearAgo = today.subtract(Duration(days: 365));
      while (today.isAfter(aYearAgo)) {
        String historyKey =
            'meditation-${today.day}-${today.month}-${today.year}';
        String historyValue = getValue(historyKey);
        if (historyValue != "") {
          meditationHistory[historyKey] = double.parse(historyValue).round();
        }
        today = today.subtract(Duration(days: 1));
      }

      await Api.user
          .updateUserAttribute("meditationHistory", meditationHistory);
    }
  }

  void loadData() {
    // Print loading message
    logInfo("Loading Data!");

    // Load total meditation minutes if available
    if (getValue('total_minutes') != "") {
      totalMinutes.value = int.parse(getValue('total_minutes'));
    }

    // Initialize lists for the last seven days of meditation and unlocked turtles
    lastSevenDays = RxList.empty();
    unlockedTurtles = RxList.empty();

    // Load meditation data for the last seven days
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      String meditationKey =
          'meditation-${today.day}-${today.month}-${today.year}';
      if (getValue(meditationKey) != "") {
        lastSevenDays.add(double.parse(getValue(meditationKey)));
      } else {
        lastSevenDays.add(0.0);
      }
      today = today.subtract(const Duration(days: 1));
    }

    // Load gems, eggs, and other related data
    if (getValue('gems') != "") {
      gems.value = int.parse(getValue('gems'));
    }
    if (getValue('eggs') != "") {
      eggs.value = int.parse(getValue('eggs'));
    }
    if (getValue('total_eggs') != "") {
      totalEggs.value = int.parse(getValue('total_eggs'));
    }
    if (getValue('egg_progress_one') != "") {
      hatchProgressEggOne.value = int.parse(getValue('egg_progress_one'));
    }

    // Load egg types
    if (getValue('egg_types') != "") {
      List<String> eggTypesValue =
          getValue('egg_types').replaceAll(" ", "").split(",");
      eggType = RxList.empty();
      for (String type in eggTypesValue) {
        eggType.add(type);
      }
      logInfo("Egg types: " + eggType.toString());
    }

    // Load streak freeze value
    if (getValue('streak_freezes') != "") {
      streakFreezes.value = int.parse(getValue('streak_freezes'));
    }

    // Load unlocked turtle data
    for (int i = 0; i < TURTLES.length; i++) {
      if (getValue('turtle-${i}') != "") {
        unlockedTurtles.add(int.parse(getValue('turtle-${i}')));

        if (getValue('turtle-${i}-color') != "") {
          unlockedTurtleColors.add(
              getValue('turtle-${i}-color').split(',').map(int.parse).toList());
          unlockedTurtleColors[i].add(-1);
        } else {
          // Generate random turtle colors if not available
          unlockedTurtleColors.add(List<int>.generate(
              int.parse(getValue('turtle-${i}')),
              (i) => Random().nextInt(TURTLE_COLORS.length)));

          saveValue(
              "turtle-${i}-color",
              unlockedTurtleColors[i]
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", ""));
        }
      } else {
        unlockedTurtles.add(0);
        unlockedTurtleColors.add([-1]);
      }
    }

    // Load ambience setting
    if (getValue('ambience_on') != "") {
      ambienceOn.value = getValue('ambience_on').toLowerCase() == 'true';
    }

    // Load default meditation time
    if (getValue('default_meditation_time') != "") {
      defaultMeditationTime.value =
          int.parse(getValue('default_meditation_time'));
    }

    // Load current streak value
    streak.value = loadStreak();

    // Load the entire meditation history for the past year
    // If gems does not exist, neither does meditation history yet
    if (getValue('gems') == "") {
      DateTime rn = DateTime.now();
      today = DateTime.now();
      while (rn.difference(today).abs().inDays <= 365) {
        DateTime simpleDate = DateTime(today.year, today.month, today.day);
        meditationHistory[simpleDate] = (double.tryParse(getValue(
                    'meditation-${today.day}-${today.month}-${today.year}')) ??
                0.0)
            .round();
        today = today.subtract(Duration(days: 1));
      }
    }

    // Handle potential issue with a vast number of egg types

    if (eggType.length > eggs.value && eggType.length > 30) {
      logWarning("CLEARING EGG ISSUE 🥚, eggType is " +
          eggType.length.toString() +
          " and eggs is " +
          eggs.value.toString());
      for (int i = 0; i < (eggType.length - eggs.value); i++) {
        eggType.removeLast();
      }
      saveValue("egg_types",
          eggType.toString().replaceAll("[", "").replaceAll("]", ""));
    }

    // Notify observers of the changes
    update();

    logInfo("Streak is set to ${streak.value}");
  }

  Future<void> saveValue(String key, String value) async {
    storage.write(key, value);
    uploadLocalData();
  }

  String getValue(String key) {
    return storage.read(key) ?? "";
  }

  Future<void> clearValue(String key) async {
    storage.remove(key);
  }

  int loadStreak() {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    //TODO: check last_meditated to see whats going on
    if (getValue("last_meditated") == "") {
      logInfo("last_meditated hasn't been set yet.");
      return 0;
    } else {
      int numDays = DateTime.parse(getValue("last_meditated"))
          .difference(date)
          .inDays
          .abs();

      if (numDays >= 1) {
        hasDoneStreakToday.value = false;
      }

      if (numDays <= 1) {
        if (numDays < 1) {
          hasDoneStreakToday.value = true;
          update();
        }
        logInfo("NumDays < 1");
        if (getValue("streak") == "") {
          logInfo("Streak hasn't been saved yet!!");
          return 0;
        } else {
          logInfo("Parsing streak...");
          return int.parse(getValue("streak"));
        }
      } else {
        //If you lose your streak

        //Use a streak freeze if possible
        if (streakFreezes.value > 0) {
          //idk how this edge case could happen but maybe it could
          if (getValue("streak") == "") {
            logInfo("Streak hasn't been saved yet!!");
            return 0;
          } else {
            DateTime now = DateTime.now();
            DateTime today = DateTime(now.year, now.month, now.day);
            DateTime yesterday = today.subtract(const Duration(days: 1));
            saveValue("last_meditated", yesterday.toIso8601String());
            updateStreakFreezes(streakFreezes.value - 1);
            logInfo("Streak freeze has been used. Returning streak.");
            return int.parse(getValue("streak"));
          }
        } else {
          updateStreak(0);
          return 0;
        }
      }
    }
  }

  void updateStreak(int newValue) {
    hasDoneStreakToday.value = true;
    saveValue("streak", newValue.toString());
    streak.value = newValue;
    update();
  }

  void updateTotalAmount(int newValue, int amountNew) {
    saveValue("total_minutes", newValue.toString());
    totalMinutes.value = newValue;

    DateTime today = DateTime.now();
    if (getValue('meditation-${today.day}-${today.month}-${today.year}') ==
        "") {
      saveValue('meditation-${today.day}-${today.month}-${today.year}',
          amountNew.toString());
    } else {
      saveValue(
          'meditation-${today.day}-${today.month}-${today.year}',
          (double.parse(getValue(
                      'meditation-${today.day}-${today.month}-${today.year}')) +
                  amountNew)
              .toString());
    }

    lastSevenDays[0] += amountNew;

    DateTime simpleDate = new DateTime(today.year, today.month, today.day);
    if (meditationHistory[simpleDate] != null) {
      int oldValue = meditationHistory.remove(simpleDate) ?? 0;
      meditationHistory.addAll({simpleDate: oldValue + amountNew});
      logInfo(
          "Updating meditationHistory for today! There was already a value here but the new meditation amount has been appended.");
    } else {
      meditationHistory.addAll({simpleDate: amountNew});
      logInfo(
          "Updating meditationHistory for today! First time meditating for today, so a new key/value was added.");
    }
    meditationHistory.refresh();
    update();
  }

  void updateGems(int newValue) {
    saveValue("gems", newValue.toString());
    gems.value = newValue;
    update();
  }

  void updateEggs(int newValue) {
    saveValue("eggs", newValue.toString());
    eggs.value = newValue;
    update();
  }

  void updateTotalEggs(int newValue) {
    saveValue("total_eggs", newValue.toString());
    totalEggs.value = newValue;
    update();
  }

  void updateHatchProgress(int newValue) {
    saveValue("egg_progress_one", newValue.toString());
    hatchProgressEggOne.value = newValue;
    update();
  }

  void addUnlockedTurtle(int i, int addAmount, int turtleColorToHatch) {
    logInfo("Color of turtle to hatch: " + turtleColorToHatch.toString());
    logInfo("Number of turtles to add: " + addAmount.toString());
    saveValue("turtle-${i}", (unlockedTurtles[i] + addAmount).toString());
    unlockedTurtles[i] += addAmount;

    if (getValue("turtle-${i}-color") != "") {
      saveValue("turtle-${i}-color",
          getValue('turtle-${i}-color') + "," + turtleColorToHatch.toString());
      logInfo("getValue for turtle-i-color returned an existing value.");
    } else {
      saveValue("turtle-${i}-color", turtleColorToHatch.toString());
      logInfo("getValue for turtle-i-color was empty.");
    }
    unlockedTurtleColors[i].add(turtleColorToHatch);
    logInfo("UNLOCKED TURTLE COLORS: " + unlockedTurtleColors.toString());
    update();
  }

  void updateStreakFreezes(int newValue) {
    saveValue("streak_freezes", newValue.toString());
    streakFreezes.value = newValue;
    update();
  }

  String COOKIES_KEY = "cookies";

  Future<void> saveCookies(String cookies) async {
    logInfo("Saving cookies: $cookies -> $COOKIES_KEY");
    storage.write(COOKIES_KEY, cookies);
  }

  String getCookies() {
    return storage.read(COOKIES_KEY) ?? "";
  }

  Future<void> clearCookies() async {
    storage.remove(COOKIES_KEY);
  }

  RxInt selectedTurtle = 0.obs;
  RxInt turtleColor = 0.obs;
  BuildContext? localContext;

  //TODO: move to another controller
  void startGame(int turtleID, int turtleColorNew, BuildContext context) {
    selectedTurtle.value = turtleID;
    turtleColor.value = turtleColorNew;
    localContext = context;
    update();
  }

  void addFutureTurtle(int futureColor, int futureType) {
    logInfo(
        'Add future turtle called, adding $futureType-$futureColor to egg_types');

    eggType.add("$futureType-$futureColor");

    saveValue("egg_types",
        eggType.toString().replaceAll("[", "").replaceAll("]", ""));
    update();
  }

  void popFutureTurtle() {
    eggType.removeAt(0);
    saveValue("egg_types",
        eggType.toString().replaceAll("[", "").replaceAll("]", ""));
    update();
  }

  void hatchTurtle(int i, int turtleColorToHatch) {
    if (eggType.isNotEmpty) {
      String eggTypeNew = eggType[0];
      int eggTypeNewInt = int.parse(eggTypeNew.split("-")[0]);
      int eggColorNewInt = int.parse(eggTypeNew.split("-")[1]);
      logInfo("Hatching turtle $eggTypeNewInt-$eggColorNewInt (type-color)");
      addUnlockedTurtle(eggTypeNewInt, 1, eggColorNewInt);
      popFutureTurtle();
    } else {
      addUnlockedTurtle(i, 1, turtleColorToHatch);
    }
  }
}
