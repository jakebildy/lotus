import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:meditate_app/util/logger.dart';

/// SaveController is going to be deprecated. It will only be used for the saved settings.
/// {@category Controllers}
class SaveController extends GetxController {
  final storage = GetStorage();

  //Saved Settings
  RxInt defaultMeditationTime = 2.obs;
  RxBool ambienceOn = true.obs;
  RxBool hasReviewed = false.obs;
  RxBool requestNotifications = false.obs;
  RxString selectedAmbience = "Water Sounds".obs;
  RxBool isSubscribedToPremium = false.obs;
  RxInt topPercentage = (-1).obs;

  RxBool loadingSaveController = true.obs;
  //A map of the user's meditation history, with the date as the key and the amount meditated in minutes as the value
  RxMap<DateTime, int> meditationHistory = RxMap();

  void updateAmbience() {
    ambienceOn.value = !ambienceOn.value;
    saveValue("ambience_on", ambienceOn.value.toString());
    update();
  }

  void updateSelectedAmbience(String newVal) {
    selectedAmbience.value = newVal;
    saveValue("selected_ambience", selectedAmbience.value);
    update();
  }

  void updateDefaultMeditationTime(int newVal) {
    defaultMeditationTime.value = newVal;
    saveValue(
        "default_meditation_time", defaultMeditationTime.value.toString());
    update();
  }

  void updateHasReviewed() {
    hasReviewed.value = true;
    saveValue("has_reviewed", hasReviewed.value.toString());
    update();
  }

  void updateRequestNotifications() {
    requestNotifications.value = !requestNotifications.value;
    saveValue("request_notifications", requestNotifications.value.toString());
    update();
  }

  void updateIsSubscribedToPremium(bool newVal) {
    isSubscribedToPremium.value = newVal;
    saveValue("SHELLEVATE_PREMIUM_RC", isSubscribedToPremium.value.toString());
    update();
  }

  void updateTopPercentage(int newVal) {
    topPercentage.value = newVal;
    saveValue("top_percentage", topPercentage.value.toString());
    update();
  }

  // void updateFetchedData(User user) {
  //   meditationHistory.value = user.meditationHistory;
  //   // unlockedTurtles.value = user.unlockedTurtles;
  //   // unlockedTurtleColors.value = user.unlockedTurtleColors;
  //   meditationHistory.refresh();
  //   update();
  // }

  SaveController() {
    loadData();
  }

  // Future<void> uploadLocalData() async {
  //   // Upload simple attributes
  //   // await Api.user.updateUserAttribute("streak", streak.value);
  //   // await Api.user.updateUserAttribute("totalMinutes", totalMinutes.value);
  //   // await Api.user.updateUserAttribute("gems", gems.value);
  //   // await Api.user.updateUserAttribute("totalEggs", totalEggs.value);
  //   // await Api.user
  //   // .updateUserAttribute("hatchProgressEggOne", hatchProgressEggOne.value);

  //   // Upload last meditated date
  //   String lastMeditated = getValue("last_meditated");
  //   if (lastMeditated != "") {
  //     await api.user.updateUserAttribute("lastMeditated", lastMeditated);
  //   }

  //   // Upload meditation times for the past week
  //   List<double> meditationTimes = [];
  //   DateTime today = DateTime.now();
  //   DateTime date = DateTime(today.year, today.month, today.day);
  //   for (int i = 0; i < 7; i++) {
  //     String key = 'meditation-${today.day}-${today.month}-${today.year}';
  //     String value = getValue(key);
  //     meditationTimes.add(value != "" ? double.parse(value) : 0.0);
  //     today = today.subtract(const Duration(days: 1));
  //   }
  //   await api.user.updateUserAttribute("meditationTimes", meditationTimes);
  //   await api.user
  //       .updateUserAttribute("meditationTimesAsOf", date.toIso8601String());

  //   // Upload unlocked turtles by their names
  //   List<String> unlockedTurtlesNames = [];
  //   for (Turtle turtle in TURTLES) {
  //     String turtleKey = 'turtle-${turtle.name}';
  //     String turtleValue = getValue(turtleKey);
  //     if (turtleValue != "") {
  //       unlockedTurtlesNames.add(turtle.name);
  //     }
  //   }
  //   await api.user.updateUserAttribute("unlockedTurtles", unlockedTurtlesNames);

  //   // Upload unlocked turtle colors
  //   List<List<int>> unlockedTurtleColors = [];
  //   for (Turtle turtle in TURTLES) {
  //     String turtleColorKey = 'turtle-${turtle.name}-color';
  //     String turtleColorValue = getValue(turtleColorKey);
  //     if (turtleColorValue != "") {
  //       List<int> colors = turtleColorValue
  //           .split(',')
  //           .map((color) => int.parse(color.trim()))
  //           .toList();
  //       unlockedTurtleColors.add(colors);
  //     }
  //   }
  //   await api.user
  //       .updateUserAttribute("unlockedTurtleColors", unlockedTurtleColors);

  //   // Upload the entire me ditation history for the past year
  //   if (lastMeditated != "") {
  //     Map<String, int> meditationHistory = {};
  //     today = DateTime.now(); // reset today to current date
  //     DateTime aYearAgo = today.subtract(const Duration(days: 365));
  //     while (today.isAfter(aYearAgo)) {
  //       String historyKey =
  //           'meditation-${today.day}-${today.month}-${today.year}';
  //       String historyValue = getValue(historyKey);
  //       if (historyValue != "") {
  //         meditationHistory[historyKey] = double.parse(historyValue).round();
  //       }
  //       today = today.subtract(const Duration(days: 1));
  //     }

  //     await api.user
  //         .updateUserAttribute("meditationHistory", meditationHistory);
  //   }
  // }

  void loadData() {
    // Print loading message
    logInfo("Loading Data!");

    // Load unlocked turtle data
    // for (int i = 0; i < TURTLES.length; i++) {
    //   if (getValue('turtle-$i') != "") {
    //     unlockedTurtles.add(int.parse(getValue('turtle-$i')));

    //     if (getValue('turtle-$i-color') != "") {
    //       unlockedTurtleColors.add(
    //           getValue('turtle-$i-color').split(',').map(int.parse).toList());
    //       unlockedTurtleColors[i].add(-1);
    //     } else {
    //       // Generate random turtle colors if not available
    //       unlockedTurtleColors.add(List<int>.generate(
    //           int.parse(getValue('turtle-$i')),
    //           (i) => Random().nextInt(TURTLE_COLORS.length)));

    //       saveValue(
    //           "turtle-$i-color",
    //           unlockedTurtleColors[i]
    //               .toString()
    //               .replaceAll("[", "")
    //               .replaceAll("]", ""));
    //     }
    //   } else {
    //     unlockedTurtles.add(0);
    //     unlockedTurtleColors.add([-1]);
    //   }
    // }

    // Load ambience setting
    if (getValue('ambience_on') != "") {
      ambienceOn.value = getValue('ambience_on').toLowerCase() == 'true';
    }

    // Load selected ambience
    if (getValue('selected_ambience') != "") {
      selectedAmbience.value = getValue('selected_ambience');
    } else {
      selectedAmbience.value = "Water Sounds";
    }

    // Load default meditation time
    if (getValue('default_meditation_time') != "") {
      defaultMeditationTime.value =
          int.parse(getValue('default_meditation_time'));
    }

    // Load if the user has been prompted to rate the app
    if (getValue('has_reviewed') != "") {
      hasReviewed.value = getValue('has_reviewed').toLowerCase() == 'true';
    }

    //Load if notifications have been requested
    if (getValue('request_notifications') != "") {
      requestNotifications.value =
          getValue('request_notifications').toLowerCase() == 'true';
    }

    // Load if the user is subscribed to premium
    if (getValue('SHELLEVATE_PREMIUM_RC') != "") {
      isSubscribedToPremium.value =
          getValue('SHELLEVATE_PREMIUM_RC').toLowerCase() == 'true';
    }

    if (getValue('top_percentage') != "") {
      topPercentage.value = int.parse(getValue('top_percentage'));
    }

    loadingSaveController.value = false;

    // Handle potential issue with a vast number of egg types

    // if (eggType.length > eggs.value && eggType.length > 30) {
    //   logWarning("CLEARING EGG ISSUE 🥚, eggType is " +
    //       eggType.length.toString() +
    //       " and eggs is " +
    //       eggs.value.toString());
    //   for (int i = 0; i < (eggType.length - eggs.value); i++) {
    //     eggType.removeLast();
    //   }
    //   saveValue("egg_types",
    //       eggType.toString().replaceAll("[", "").replaceAll("]", ""));
    // }

    // Notify observers of the changes
    update();
  }

  Future<void> saveValue(String key, String value) async {
    storage.write(key, value);
  }

  String getValue(String key) {
    return storage.read(key) ?? "";
  }

  Future<void> clearValue(String key) async {
    storage.remove(key);
  }
}
