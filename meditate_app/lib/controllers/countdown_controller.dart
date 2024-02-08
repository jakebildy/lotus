import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/egg_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/pages/streak_count_page.dart';
import 'package:meditate_app/services/heap_service.dart';
import 'package:meditate_app/util/ambiences.dart';
import 'package:meditate_app/util/eggquation.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:ocarina/ocarina.dart';

import '../util/DEBUG_MODE.dart';
import '../util/logger.dart';

/// CountdownController manages the logic for the meditation countdown
/// {@category Controllers}
class CountdownController extends GetxController {
  RxInt tenthsOfSecondsPassed = 0.obs;

  RxInt totalSeconds = 0.obs;

  RxBool meditationComplete = false.obs;
  RxBool isPaused = false.obs;

  //The countdown timer that starts as soon as the meditation starts
  late Timer countdownTimer;

  // Current DateTime
  DateTime lastCountdownTimerTime = DateTime.now();

  // Migrating some stuff from countdown page
  late AudioPlayer bell;
  RxBool addExtraTime = false.obs;

  /// Whether the Continue button is loading after being pressed
  RxBool loading = false.obs;

  CountdownController() {
    bell = AudioPlayer();
    bell.setVolume(5.0);
  }

  late OcarinaPlayer player;
  Future<void> playAmbience() async {
    SaveController save = Get.find();
    if (save.selectedAmbience.value != "None") {
      player = OcarinaPlayer(
        asset: AMBIENCES
            .where((element) => element.name == save.selectedAmbience.value)
            .first
            .audio,
        loop: true,
        volume: 0.8,
      );

      await player.load();
      await player.play();
    }
  }

  void startCountdownTimer() {
    bell.play(AssetSource('audio/tibetan_chime.wav'));
    SaveController saveController = Get.find();

    if (saveController.ambienceOn.value) {
      playAmbience();
    }

    tenthsOfSecondsPassed.value = 0;
    meditationComplete.value = false;
    const hundredMilliseconds = Duration(seconds: 0, milliseconds: 100);
    logSuccess("Starting countdown");
    countdownTimer = Timer.periodic(
      hundredMilliseconds,
      (Timer timer) {
        tenthsOfSecondsPassed.value = ++tenthsOfSecondsPassed.value;
        if (tenthsOfSecondsPassed.value >= totalSeconds.value * 10) {
          completeCountdownTimer();
        }
        update();
      },
    );
  }

  void pauseCountdownTimer() {
    SaveController save = Get.find();
    logSuccess("Pausing countdown");

    if (save.selectedAmbience.value != "None") {
      player.pause();
    }

    countdownTimer.cancel();
    isPaused = true.obs;
    update();
  }

  void resumeCountdownTimer() {
    logSuccess("Resuming countdown");
    SaveController save = Get.find();
    if (save.selectedAmbience.value != "None") {
      player.resume();
    }

    const hundredMilliseconds = Duration(seconds: 0, milliseconds: 100);

    countdownTimer = Timer.periodic(
      hundredMilliseconds,
      (Timer timer) {
        tenthsOfSecondsPassed.value = ++tenthsOfSecondsPassed.value;

        if (tenthsOfSecondsPassed.value >= totalSeconds.value * 10) {
          completeCountdownTimer();
        }
        update();
      },
    );
    isPaused = false.obs;
    update();
  }

  void disposeTimer() {
    SaveController save = Get.find();
    if (save.selectedAmbience.value != "None") {
      player.dispose();
    }
    bonusTimer.cancel();
    countdownTimer.cancel();
    bell.dispose();
  }

  void pauseApp() {
    if (!isPaused.value) {
      logSuccess("App paused, saving current time");
      lastCountdownTimerTime = DateTime.now();
    }
  }

  void resumeApp() {
    if (!isPaused.value) {
      logSuccess("App resumed, calculating time passed");
      DateTime now = DateTime.now();
      int timePassed = now.difference(lastCountdownTimerTime).inSeconds;
      tenthsOfSecondsPassed.value += timePassed * 10;
      lastCountdownTimerTime = now;

      // if tenthsOfSecondsPassed is greater than totalSeconds, then add to bonusTime
      if (tenthsOfSecondsPassed.value ~/ 10 > totalSeconds.value) {
        bonusTime.value +=
            (tenthsOfSecondsPassed.value ~/ 10) - totalSeconds.value;
        tenthsOfSecondsPassed.value = totalSeconds.value * 10;
      }
      update();
    }
  }

  void completeCountdownTimer() {
    logSuccess("Countdown complete");
    SaveController save = Get.find();
    meditationComplete.value = true;
    countdownTimer.cancel();
    tenthsOfSecondsPassed.value = 0;

    // isEnded = true;
    logInfo('Countdown Ended');
    if (save.selectedAmbience.value != "None") {
      player.dispose();
    }
    bell.dispose();

    AudioPlayer endingBell = AudioPlayer();
    endingBell.setVolume(5.0);
    endingBell.play(AssetSource('audio/tibetan_chime.wav'));
    startBonusTimer();
    update();
  }

  // The timer that starts as soon as the meditation concludes
  late Timer bonusTimer;
  RxInt bonusTime = 0.obs;

  // Current DateTime
  DateTime lastTimerTime = DateTime.now();

  void startBonusTimer() {
    const oneSec = Duration(seconds: 1);

    bonusTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        bonusTime.value += 1;
        lastTimerTime = DateTime.now();
        update();
      },
    );
  }

  void submitMeditation() {
    loading.value = true;
    update();
    UserController userController = Get.find();
    SaveController save = Get.find();
    EggController eggController = Get.find();

    int turtleToHatch = -1;
    int turtleColorToHatch = -1;

    int timeInMinutes = totalSeconds.value ~/ 60;
    if (addExtraTime.value) {
      timeInMinutes += bonusTime.value ~/ 60;
    }
    logInfo("Time in Minutes to add: $timeInMinutes");

    //Save the streak day
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);

    int gemsToGive = 0;
    bool alreadyMeditatedToday = false;

    int numDays =
        userController.user.value.lastMeditated.difference(date).inDays.abs();
    if (numDays == 1) {
      userController.updateStreak(userController.user.value.streak + 1);
      logInfo(
          "Streak value is updated to ${userController.user.value.streak} + 1}.");
      userController.updateProperty(
          UserProperty.gems, userController.user.value.gems + 5);
      gemsToGive += 5;
    } else if (numDays > 1) {
      userController.updateStreak(1);
      userController.updateProperty(
          UserProperty.gems, userController.user.value.gems + 5);
      gemsToGive += 5;
      logInfo("Streak value is set to 1. NumDays was > 1.");
    } else {
      logInfo("You already meditated today. Not updating streak!");
      alreadyMeditatedToday = true;
    }

    userController.logMeditation(timeInMinutes, date);

    userController.updateProperty(
        UserProperty.gems, userController.user.value.gems + timeInMinutes);
    gemsToGive += timeInMinutes;

    if (!alreadyMeditatedToday || DEBUG_MODE) {
      //Updating the egg progress if haven't already meditated today
      logInfo("First time meditating today");
      if (userController.user.value.eggs > 0) {
        if (userController.user.value.hatchProgressEggOne >= 2) {
          //Hatch a turtle!

          logInfo("HATCHING A TURTLE!");
          turtleToHatch = getTurtleToHatch(save.selectedAmbience.value);
          turtleColorToHatch = Random().nextInt(TURTLE_COLORS.length);

          //if future turtles exist, this will be the one that displays on the
          //hatching turtle page
          if (userController.user.value.eggTypes.isNotEmpty) {
            String eggTypeNew = userController.user.value.eggTypes[0];
            turtleToHatch = int.parse(eggTypeNew.split("-")[0]);
            turtleColorToHatch = int.parse(eggTypeNew.split("-")[1]);
          }

          eggController.hatchTurtle(turtleToHatch, turtleColorToHatch);
        } else {
          logInfo("Updating hatch process");

          userController.updateProperty(UserProperty.hatchProgressEggOne,
              userController.user.value.hatchProgressEggOne + 1);
        }
      }
    }

    //find an egg potentially
    bool foundEgg = receiveEgg(timeInMinutes);
    if (foundEgg) {
      int tHatch = getTurtleToHatch(save.selectedAmbience.string);
      int tColor = Random().nextInt(TURTLE_COLORS.length);

      eggController.addEgg(tColor, tHatch);
    }

    //Log the event to AppsFlyer
    HeapService heap = Get.find();
    heap.logEvent("MEDITATION_COMPLETE", {"time": timeInMinutes.toString()});

    bonusTimer.cancel();

    loading.value = false;
    bonusTime.value = 0;
    update();

    Get.offAll(StreakCountPage(
      gemsAmount: gemsToGive,
      alreadyMeditatedToday: alreadyMeditatedToday,
      foundEgg: foundEgg,
      turtleToHatch: turtleToHatch,
      turtleColorToHatch: turtleColorToHatch,
    ));
  }
}
