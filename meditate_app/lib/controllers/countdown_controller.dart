import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
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
import 'package:just_audio/just_audio.dart' as just_audio;

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

  late OcarinaPlayer player;
  late just_audio.AudioPlayer networkAudioPlayer;

  CountdownController() {
    bell = AudioPlayer();
    networkAudioPlayer = just_audio.AudioPlayer();
    networkAudioPlayer.setLoopMode(just_audio.LoopMode.all);
    bell.setVolume(2.0);
  }

  Future<void> playAmbience() async {
    SaveController save = Get.find();
    if (save.selectedAmbience.value != "None") {
      if (AMBIENCES
          .where((element) => element.name == save.selectedAmbience.value)
          .first
          .audio
          .startsWith("https")) {
        await networkAudioPlayer.setUrl(AMBIENCES
            .where((element) => element.name == save.selectedAmbience.value)
            .first
            .audio); // Schemes: (https: | file: | asset: )
        await networkAudioPlayer.play();

        // networkAudioPlayer.play(audioUrl);
        // networkAudioPlayer.setReleaseMode(ReleaseMode.loop);
      } else {
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
  }

  void startCountdownTimer() {
    bell.play(AssetSource('audio/tibetan_chime.wav'));
    SaveController saveController = Get.find();

    if (saveController.ambienceOn.value) {
      playAmbience();
    }

    tenthsOfSecondsPassed.value = 0;
    bonusTime.value = 0;
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
      if (AMBIENCES
          .where((element) => element.name == save.selectedAmbience.value)
          .first
          .audio
          .startsWith("https")) {
        networkAudioPlayer.pause();
      } else {
        player.pause();
      }
    }

    countdownTimer.cancel();
    isPaused = true.obs;
    update();
  }

  void resumeCountdownTimer() {
    logSuccess("Resuming countdown");
    SaveController save = Get.find();
    if (save.selectedAmbience.value != "None") {
      if (AMBIENCES
          .where((element) => element.name == save.selectedAmbience.value)
          .first
          .audio
          .startsWith("https")) {
        networkAudioPlayer.play();
      } else {
        player.resume();
      }
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
      if (AMBIENCES
          .where((element) => element.name == save.selectedAmbience.value)
          .first
          .audio
          .startsWith("https")) {
        networkAudioPlayer.stop();
        // networkAudioPlayer.dispose();
      } else {
        player.dispose();
      }
    }
    try {
      bonusTimer.cancel();
    } catch (e) {
      logError("Error disposing bonusTimer: $e");
    }

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
      logInfo("Last time: $lastCountdownTimerTime");
      int timePassed = now.difference(lastCountdownTimerTime).inSeconds;
      logInfo("Time passed: $timePassed seconds");
      tenthsOfSecondsPassed.value += timePassed * 10;
      lastCountdownTimerTime = now;

      // if tenthsOfSecondsPassed is greater than totalSeconds, then add to bonusTime
      if (tenthsOfSecondsPassed.value ~/ 10 > totalSeconds.value) {
        bonusTime.value =
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
      if (AMBIENCES
          .where((element) => element.name == save.selectedAmbience.value)
          .first
          .audio
          .startsWith("https")) {
        networkAudioPlayer.stop();
        // networkAudioPlayer.dispose();
      } else {
        player.dispose();
      }
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

  //This does not appear to have any bugs...
  Future<void> submitMeditation() async {
    // Update the button to a loading state so you can't press it again
    loading.value = true;
    update();

    //Initialize the controllers
    UserController userController = Get.find();
    SaveController save = Get.find();
    EggController eggController = Get.find();

    // Initialize the egg variables (only matter if an egg is found)
    int turtleToHatch = -1;
    int turtleColorToHatch = -1;

    // Calculate the time in minutes
    int timeInMinutes = totalSeconds.value ~/ 60;

    // Add the bonus time if the user selected it
    if (addExtraTime.value) {
      timeInMinutes += bonusTime.value ~/ 60;
    }
    logInfo("Time in Minutes to add: $timeInMinutes");

    //The meditationHistory date
    DateTime now = DateTime.now();
    DateTime date = DateTime.utc(now.year, now.month, now.day);
    // TODO: this is where the bug is with streak count not updating

    // The number of gems to give
    int gemsToGive = 0;

    // Check if the user has already meditated today
    bool alreadyMeditatedToday = false;

    int numDays =
        userController.user.value.lastMeditated.difference(date).inDays.abs();

    // This section updates the streak, alreadyMeditatedToday
    // and allocates bonus gems (sand dollars)

    // If you meditated yesterday (or used a streak freeze for yesterday)
    if (numDays == 1) {
      userController.updateStreak(userController.user.value.streak + 1);
      logInfo(
          "Streak value is updated to ${userController.user.value.streak} + 1.");

      //Bonus five sand dollars for first time meditating today
      userController.updateProperty(UserProperty.gems,
          (userController.user.value.gems + 5 + timeInMinutes));
      gemsToGive += 5;
      gemsToGive += timeInMinutes;
      // If it's been longer than a day since the last meditation and no streak freeze was used for yesterday
    } else if (numDays > 1) {
      userController.updateStreak(1);
      userController.updateProperty(UserProperty.gems,
          (userController.user.value.gems + 5 + timeInMinutes));
      gemsToGive += 5;
      gemsToGive += timeInMinutes;
      logInfo("Streak value is set to 1. NumDays was > 1.");
    } else {
      logInfo("You already meditated today. Not updating streak!");
      alreadyMeditatedToday = true;
      userController.updateProperty(
          UserProperty.gems, (userController.user.value.gems + timeInMinutes));
      gemsToGive += timeInMinutes;
    }

    // Logs the meditation (updates lastMeditated, totalMinutes, and meditationHistory)
    userController.logMeditation(timeInMinutes, date);

    // If this is the first meditation of the day or you're in debug mode
    if (!alreadyMeditatedToday || DEBUG_MODE) {
      //Updating the egg progress if haven't already meditated today
      logInfo("First time meditating today");
      if (userController.user.value.eggs > 0) {
        if (userController.user.value.hatchProgressEggOne >= 2) {
          //Hatch a turtle!

          logInfo("HATCHING A TURTLE!");
          turtleToHatch = getTurtleToHatch(save.selectedAmbience.value);

          // TODO: make this only hatch rainbow if a rainbow flame
          turtleColorToHatch = Random().nextInt(TURTLE_COLORS.length);

          //if future turtles exist, this will be the one that displays on the
          //hatching turtle page
          if (userController.user.value.eggTypes.isNotEmpty) {
            String eggTypeNew = userController.user.value.eggTypes[0];
            turtleToHatch = int.parse(eggTypeNew.split("-")[0]);
            turtleColorToHatch = int.parse(eggTypeNew.split("-")[1]);
          }

          await eggController.hatchTurtle(turtleToHatch, turtleColorToHatch);
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

      await eggController.addEgg(tColor, tHatch);
    }
    //Log the event to AppsFlyer
    HeapService heap = Get.find();
    heap.logEvent("MEDITATION_COMPLETE", {"time": timeInMinutes.toString()});

    try {
      bonusTimer.cancel();
    } catch (e) {
      logError(e.toString());
    }

    loading.value = false;
    bonusTime.value = 0;
    update();

    Get.offAll(StreakCountPage(
      gemsAmount: gemsToGive,
      alreadyMeditatedToday: alreadyMeditatedToday,
      foundEgg: foundEgg,
      levelUp: true,
      turtleToHatch: turtleToHatch,
      turtleColorToHatch: turtleColorToHatch,
    ));
  }
}
