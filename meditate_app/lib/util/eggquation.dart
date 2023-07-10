// This is the equation to calcluate whether an egg should be given
import 'dart:math';

import 'package:get/get.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/util/DEBUG_MODE.dart';

bool receiveEgg(int timeMeditated) {
  print("Calculating the Eggquation 🥚:");
  print("Time meditated is $timeMeditated");
  SaveController save = Get.find();

  double chanceOfEgg = save.totalEggs.value == 0
      ? 1.0
      : ((timeMeditated / 30) > 1
          ? 0.4
          : (timeMeditated / 10) >= 1
              ? 0.125
              : 0.1);

  if (DEBUG_MODE) {
    chanceOfEgg = 1;
  }

  print("Chance of egg:");
  print(chanceOfEgg);
  return Random().nextDouble() <= chanceOfEgg;
}
