import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class SaveController extends GetxController {
  final storage = GetStorage();

  RxInt streak = 0.obs;
  RxInt totalMinutes = 0.obs;
  RxInt gems = 0.obs;
  RxBool hasDoneStreakToday = false.obs;

  RxBool ambienceOn = true.obs;

  RxList lastSevenDays = new RxList();

  void updateAmbience() {
    ambienceOn.value = !ambienceOn.value;
    update();
  }

  double streakAverage() {
    double sum = 0;
    for (double i in lastSevenDays) {
      sum += i;
    }
    return sum/7;
  }

  SaveController() {
    streak.value = loadStreak();
    if (getValue('total_minutes') != "") {
      totalMinutes.value = int.parse(getValue('total_minutes'));
    }

    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
       if (getValue('meditation-${today.day}-${today.month}-${today.year}') != "") {
         lastSevenDays.add(double.parse(getValue('meditation-${today.day}-${today.month}-${today.year}')));
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
      int numDays = DateTime.parse(getValue("last_meditated")).difference(date).inDays.abs();

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
         updateStreak(0);
        return 0;
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
     if (getValue('meditation-${today.day}-${today.month}-${today.year}') == "") {
        saveValue('meditation-${today.day}-${today.month}-${today.year}', amountNew.toString());
     } else {
       saveValue('meditation-${today.day}-${today.month}-${today.year}', 
          (double.parse(getValue('meditation-${today.day}-${today.month}-${today.year}')) + amountNew).toString());
     }

    lastSevenDays[0] += amountNew;

    update();
  }

    void updateGems(int newValue) {
    saveValue("gems", newValue.toString());
    gems.value = newValue;
    update();
  }
}
