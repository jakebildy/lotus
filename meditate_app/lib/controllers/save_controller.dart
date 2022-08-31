import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class SaveController extends GetxController {
  final storage = GetStorage();

  RxInt streak = 0.obs;

  SaveController() {
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
      int numDays = DateTime.parse(getValue("last_meditated")).difference(date).inDays.abs();

      if (numDays <= 1) {
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
    saveValue("streak", newValue.toString());
    streak.value = newValue;
    update();
  }
}
