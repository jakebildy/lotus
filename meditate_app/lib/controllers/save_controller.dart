import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:meditate_app/util/turtles.dart';

class SaveController extends GetxController {
  final storage = GetStorage();

  RxInt streak = 0.obs;
  RxInt totalMinutes = 0.obs;
  RxInt gems = 0.obs;

  RxInt eggs = 0.obs;
  RxInt totalEggs = 0.obs;

  RxInt hatchProgressEggOne = 0.obs;

  RxBool hasDoneStreakToday = false.obs;

  RxList lastSevenDays = new RxList();

  RxInt streakFreezes = 0.obs;

  RxList unlockedTurtles = RxList();

  //Saved Settings
  RxInt defaultMeditationTime = 5.obs;
  RxBool ambienceOn = true.obs;

  void updateAmbience() {
    ambienceOn.value = !ambienceOn.value;
    saveValue("ambience_on", ambienceOn.value.toString());
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
    return hasDoneStreakToday.value
        ? streakAverage() < 20
            ? "assets/streak_icon.png"
            : streakAverage() < 40
                ? "assets/streak_icon_yellow.png"
                : streakAverage() < 60
                    ? "assets/streak_icon_blue.png"
                    : "assets/streak_icon_rainbow.png"
        : "assets/streak_icon_grey.png";
  }

  String streakIconURLBBright() {
    return streakAverage() < 20
        ? "assets/streak_icon.png"
        : streakAverage() < 40
            ? "assets/streak_icon_yellow.png"
            : streakAverage() < 60
                ? "assets/streak_icon_blue.png"
                : "assets/streak_icon_rainbow.png";
  }

  Tier streakTier() {
    return streakAverage() < 20
        ? Tier.ORANGE
        : streakAverage() < 40
            ? Tier.YELLOW
            : streakAverage() < 60
                ? Tier.BLUE
                : Tier.RAINBOW;
  }

  SaveController() {
    loadData();
  }

  void loadData() {
    print("Loading Data!");
    if (getValue('total_minutes') != "") {
      totalMinutes.value = int.parse(getValue('total_minutes'));
    }

    lastSevenDays = RxList.empty();

    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      if (getValue('meditation-${today.day}-${today.month}-${today.year}') !=
          "") {
        lastSevenDays.add(double.parse(
            getValue('meditation-${today.day}-${today.month}-${today.year}')));
        print("VALUE");
        print(getValue('meditation-${today.day}-${today.month}-${today.year}'));
      } else {
        lastSevenDays.add(0.0);
      }
      today = today.subtract(Duration(days: 1));
    }

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
    if (getValue('streak_freezes') != "") {
      streakFreezes.value = int.parse(getValue('streak_freezes'));
    }

    for (int i = 0; i < TURTLES.length; i++) {
      if (getValue('turtle-${i}') != "") {
        unlockedTurtles.add(int.parse(getValue('turtle-${i}')));
      } else {
        unlockedTurtles.add(0);
      }
    }

    if (getValue('ambience_on') != "") {
      ambienceOn.value = getValue('ambience_on').toLowerCase() == 'true';
    }

    if (getValue('default_meditation_time') != "") {
      defaultMeditationTime.value =
          int.parse(getValue('default_meditation_time'));
    }

    streak.value = loadStreak();

    update();
    print("Streak is set to ${streak.value}");
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

  int loadStreak() {
    print("Loading streak!");
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    if (getValue("last_meditated") == "") {
      print("last_meditated hasn't been set yet.");
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
        print("NumDays < 1");
        if (getValue("streak") == "") {
          print("Streak hasn't been saved yet!!");
          return 0;
        } else {
          print("Parsing streak...");
          return int.parse(getValue("streak"));
        }
      } else {
        //If you lose your streak

        //Use a streak freeze if possible
        if (streakFreezes.value > 0) {
          //idk how this edge case could happen but maybe it could
          if (getValue("streak") == "") {
            print("Streak hasn't been saved yet!!");

            return 0;
          } else {
            DateTime now = new DateTime.now();
            DateTime today = DateTime(now.year, now.month, now.day);
            DateTime yesterday = today.subtract(const Duration(days: 1));
            saveValue("last_meditated", yesterday.toIso8601String());
            updateStreakFreezes(streakFreezes.value - 1);
            print("Parsing streak...");
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

  void addUnlockedTurtle(int i, int addAmount) {
    saveValue("turtle-${i}", (unlockedTurtles[i] + addAmount).toString());
    unlockedTurtles[i] += addAmount;
    update();
  }

  void updateStreakFreezes(int newValue) {
    saveValue("streak_freezes", newValue.toString());
    streakFreezes.value = newValue;
    update();
  }

  String COOKIES_KEY = "cookies";

  Future<void> saveCookies(String cookies) async {
    print("saving cookies: $cookies -> $COOKIES_KEY");
    storage.write(COOKIES_KEY, cookies);
  }

  String getCookies() {
    return storage.read(COOKIES_KEY) ?? "";
  }

  Future<void> clearCookies() async {
    storage.remove(COOKIES_KEY);
  }
}
