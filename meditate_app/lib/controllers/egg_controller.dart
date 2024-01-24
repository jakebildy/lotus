import 'package:get/get.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/models/user.dart';

import '../util/logger.dart';

/// EggController manages the logic for selecting and hatching eggs.
/// {@category Controllers}
class EggController extends GetxController {
  UserController user = Get.find();
  void addEgg(int futureColor, int futureType) {
    logInfo(
        'Add future turtle called, adding $futureType-$futureColor to egg_types');

    var newEggTypes = user.user.value.eggTypes;
    newEggTypes.add("$futureType-$futureColor");
    user.updateProperty(UserProperty.eggTypes, newEggTypes);

    user.updateProperty(UserProperty.eggs, user.user.value.eggs + 1);
    user.updateProperty(UserProperty.totalEggs, user.user.value.totalEggs + 1);
    update();

    //TODO: this breaks on refresh. Egg appears fine initially but then when refreshing disappears. To fix, figure out 1) localstorage and database value after this function is called. 2) localstorage and database value on refresh if needed
  }

  void popEgg() {
    //create eggTypesNew and remove eggTypesNew[0]
    var newEggTypes = user.user.value.eggTypes;
    newEggTypes.removeAt(0);

    user.updateProperty(
        UserProperty.eggTypes, newEggTypes); //update eggTypes with eggTypesNew

    user.updateProperty(UserProperty.eggs, user.user.value.eggs - 1);
    user.updateProperty(UserProperty.hatchProgressEggOne, 0);
    update();
  }

  void hatchTurtle(int i, int turtleColorToHatch) {
    if (user.user.value.eggTypes.isNotEmpty) {
      String eggTypeNew = user.user.value.eggTypes[0];
      int eggTypeNewInt = int.parse(eggTypeNew.split("-")[0]);
      int eggColorNewInt = int.parse(eggTypeNew.split("-")[1]);
      logInfo("Hatching turtle $eggTypeNewInt-$eggColorNewInt (type-color)");
      addUnlockedTurtle(eggTypeNewInt, 1, eggColorNewInt);
      popEgg();
    } else {
      addUnlockedTurtle(i, 1, turtleColorToHatch);
    }
  }

  void addUnlockedTurtle(int i, int addAmount, int turtleColorToHatch) {
    logInfo("Color of turtle to hatch: " + turtleColorToHatch.toString());
    logInfo("Number of turtles to add: " + addAmount.toString());

    // saveValue("turtle-${i}", (unlockedTurtles[i] + addAmount).toString());
    var newUnlockedTurtles = user.user.value.unlockedTurtles;
    newUnlockedTurtles[i] += addAmount;
    user.updateProperty(UserProperty.unlockedTurtles, newUnlockedTurtles);

    var newUnlockedTurtleColors = user.user.value.unlockedTurtleColors;
    newUnlockedTurtleColors[i].add(turtleColorToHatch);
    user.updateProperty(
        UserProperty.unlockedTurtleColors, newUnlockedTurtleColors);
    logInfo("UNLOCKED TURTLE COLORS: " + newUnlockedTurtleColors.toString());
    update();
  }
}
