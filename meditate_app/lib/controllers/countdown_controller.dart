import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../util/logger.dart';

/// CountdownController manages the logic for the meditation countdown
/// {@category Controllers}
class CountdownController extends GetxController {
  RxInt tenthsOfSecondsPassed = 0.obs;

  //The countdown timer that starts as soon as the meditation starts
  late Timer countdownTimer;

  // Current DateTime
  DateTime lastCountdownTimerTime = DateTime.now();

  void startCountdownTimer() {
    tenthsOfSecondsPassed.value = 0;
    const hundredMilliseconds = Duration(seconds: 0, milliseconds: 100);
    logSuccess("Starting countdown");
    countdownTimer = Timer.periodic(
      hundredMilliseconds,
      (Timer timer) {
        tenthsOfSecondsPassed.value = ++tenthsOfSecondsPassed.value;
        lastCountdownTimerTime = DateTime.now();

        update();
      },
    );
  }

  void pauseCountdownTimer() {
    logSuccess("Pausing countdown");
    countdownTimer.cancel();
  }

  void resumeCountdownTimer() {
    logSuccess("Resuming countdown");
    const hundredMilliseconds = Duration(seconds: 0, milliseconds: 100);

    countdownTimer = Timer.periodic(
      hundredMilliseconds,
      (Timer timer) {
        tenthsOfSecondsPassed.value = ++tenthsOfSecondsPassed.value;
        lastCountdownTimerTime = DateTime.now();
        update();
      },
    );
  }
}
