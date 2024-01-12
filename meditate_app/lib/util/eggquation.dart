/// This is the equation to calcluate whether an egg should be given
import 'dart:math';

import 'package:get/get.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/debug_mode.dart';
import 'package:meditate_app/util/logger.dart';

bool receiveEgg(int timeMeditated) {
  UserController user = Get.find();

  double chanceOfEgg = user.user.value.totalEggs == 0
      ? 1.0
      : ((timeMeditated / 30) > 1
          ? 0.4
          : (timeMeditated / 10) >= 1
              ? 0.125
              : 0.1);

  // if (DEBUG_MODE) {
  //   chanceOfEgg = 1;
  // }

  logInfo("Time meditated is $timeMeditated. Chance of egg:" +
      chanceOfEgg.toString());

  return Random().nextDouble() <= chanceOfEgg;
}
