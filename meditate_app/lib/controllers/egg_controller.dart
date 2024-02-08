import 'package:get/get.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/models/user.dart';

import '../util/logger.dart';

/// EggController manages the logic for selecting and hatching eggs.
/// {@category Controllers}
class EggController extends GetxController {
  UserController user = Get.find();
  Future<void> addEgg(int futureColor, int futureType) async {
    logInfo(
        'Add future turtle called, adding $futureType-$futureColor to egg_types');

    var newEggTypes = user.user.value.eggTypes;
    newEggTypes.add("$futureType-$futureColor");
    await user.updateProperty(UserProperty.eggTypes, newEggTypes);

    await user.updateProperty(UserProperty.eggs, user.user.value.eggs + 1);
    await user.updateProperty(
        UserProperty.totalEggs, user.user.value.totalEggs + 1);
    update();

    //TODO: this breaks on refresh. Egg appears fine initially but then when refreshing disappears. To fix, figure out 1) localstorage and database value after this function is called. 2) localstorage and database value on refresh if needed
  }

  Future<void> popEgg() async {
    //create eggTypesNew and remove eggTypesNew[0]
    var newEggTypes = user.user.value.eggTypes;
    newEggTypes.removeAt(0);

    await user.updateProperty(
        UserProperty.eggTypes, newEggTypes); //update eggTypes with eggTypesNew

    await user.updateProperty(UserProperty.eggs, user.user.value.eggs - 1);
    await user.updateProperty(UserProperty.hatchProgressEggOne, 0);
    update();
  }

  Future<void> hatchTurtle(int i, int turtleColorToHatch) async {
    if (user.user.value.eggTypes.isNotEmpty) {
      String eggTypeNew = user.user.value.eggTypes[0];
      int eggTypeNewInt = int.parse(eggTypeNew.split("-")[0]);
      int eggColorNewInt = int.parse(eggTypeNew.split("-")[1]);
      logInfo("Hatching turtle $eggTypeNewInt-$eggColorNewInt (type-color)");
      await addUnlockedTurtle(eggTypeNewInt, 1, eggColorNewInt);
      await popEgg();
    } else {
      await addUnlockedTurtle(i, 1, turtleColorToHatch);
    }
  }

  Future<void> addUnlockedTurtle(
      int i, int addAmount, int turtleColorToHatch) async {
    logInfo("Color of turtle to hatch: " + turtleColorToHatch.toString());
    logInfo("Number of turtles to add: " + addAmount.toString());

    // saveValue("turtle-${i}", (unlockedTurtles[i] + addAmount).toString());
    var newUnlockedTurtles = user.user.value.unlockedTurtles;
    newUnlockedTurtles[i] += addAmount;
    await user.updateProperty(UserProperty.unlockedTurtles, newUnlockedTurtles);

    var newUnlockedTurtleColors = user.user.value.unlockedTurtleColors;
    newUnlockedTurtleColors[i].add(turtleColorToHatch);
    await user.updateProperty(
        UserProperty.unlockedTurtleColors, newUnlockedTurtleColors);
    logInfo("UNLOCKED TURTLE COLORS: " + newUnlockedTurtleColors.toString());
    update();
  }
}
