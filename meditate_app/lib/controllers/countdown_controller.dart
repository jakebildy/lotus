import 'dart:async';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/egg_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/pages/streak_count_page.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/ambiences.dart';
import 'package:meditate_app/util/eggquation.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayers;
// import 'package:flutter_app_badger/flutter_app_badger.dart';
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
  late audioplayers.AudioPlayer bell;
  RxBool addExtraTime = false.obs;

  /// Whether the Continue button is loading after being pressed
  RxBool loading = false.obs;

  late AudioPlayer localAudioPlayer;

  late AudioPlayer networkAudioPlayer;

  CountdownController() {
    bell = audioplayers.AudioPlayer();
    networkAudioPlayer = AudioPlayer();
    localAudioPlayer = AudioPlayer();
    localAudioPlayer.setLoopMode(LoopMode.all);
    networkAudioPlayer.setLoopMode(LoopMode.all);
    bell.setVolume(0.3);
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
      } else {
        final session = await AudioSession.instance;
        await session.configure(
          const AudioSessionConfiguration(
            avAudioSessionCategory: AVAudioSessionCategory.playback,
            avAudioSessionCategoryOptions:
                AVAudioSessionCategoryOptions.mixWithOthers,
            avAudioSessionMode: AVAudioSessionMode.defaultMode,
          ),
        );
        String assetPath = AMBIENCES
            .where((element) => element.name == save.selectedAmbience.value)
            .first
            .audio;

        await localAudioPlayer.setAsset(assetPath);
        await localAudioPlayer.setLoopMode(LoopMode.all);
        await localAudioPlayer.setVolume(0.8);
        await localAudioPlayer.play();
      }
    }
  }

  void startCountdownTimer() {
    bell.play(audioplayers.AssetSource('audio/tibetan_chime.wav'));
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
        localAudioPlayer.pause();
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
        localAudioPlayer.play();
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
      } else {
        localAudioPlayer.pause();
        // localAudioPlayer.dispose();
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

  bool appStateSetPaused = false;
  int pausedTenthsOfSecondsPassed = 0;
  void appPaused() {
    if (!isPaused.value) {
      lastCountdownTimerTime = DateTime.now();
      logSuccess("App Paused, saving current time: " +
          lastCountdownTimerTime.toString());
      logInfo("tenths of seconds passed: " +
          tenthsOfSecondsPassed.value.toString());
      appStateSetPaused = true;
      pausedTenthsOfSecondsPassed = tenthsOfSecondsPassed.value;
    }
  }

  int completedInBackgroundBonusTime = 0;

  void resumeApp() {
    if (Get.currentRoute == "/CountdownPage") {
      PostHogService posthog = Get.find();
      posthog.logEvent("APP_CLOSED_MEDITATION", {});
    }

    logInfo("resumeApp() + " +
        isPaused.value.toString() +
        " " +
        appStateSetPaused.toString());
    if (!isPaused.value && appStateSetPaused) {
      logSuccess("App resumed, calculating time passed");

      // if the page is 'CountdownPage' then log the event
      logInfo(Get.currentRoute);

      DateTime now = DateTime.now();
      logInfo("Last time: $lastCountdownTimerTime");
      int timePassed = now.difference(lastCountdownTimerTime).inSeconds;
      logInfo("Time passed: $timePassed seconds");
      logInfo("tenths of seconds passed total: " +
          (pausedTenthsOfSecondsPassed + timePassed * 10).toString());
      tenthsOfSecondsPassed.value =
          pausedTenthsOfSecondsPassed + timePassed * 10;
      lastCountdownTimerTime = now;

      // if tenthsOfSecondsPassed is greater than totalSeconds, then add to bonusTime
      if (tenthsOfSecondsPassed.value ~/ 10 > totalSeconds.value) {
        if (bonusTime.value == 0) {
          completedInBackgroundBonusTime =
              (tenthsOfSecondsPassed.value ~/ 10 - totalSeconds.value);
        } else {
          bonusTime.value += timePassed;
        }
        tenthsOfSecondsPassed.value = totalSeconds.value * 10;
      }
      appStateSetPaused = false;
      update();
    }
  }

  void completeCountdownTimer() {
    logSuccess("Countdown complete");
    SaveController save = Get.find();
    meditationComplete.value = true;
    countdownTimer.cancel();
    tenthsOfSecondsPassed.value = 0;

    if (save.selectedAmbience.value != "None") {
      if (AMBIENCES
          .where((element) => element.name == save.selectedAmbience.value)
          .first
          .audio
          .startsWith("https")) {
        networkAudioPlayer.stop();
      } else {
        // localAudioPlayer.stop();
        // localAudioPlayer.dispose();
        localAudioPlayer.pause();
      }
    }
    bell.dispose();

    audioplayers.AudioPlayer endingBell = audioplayers.AudioPlayer();
    endingBell.setVolume(0.3);
    endingBell.play(audioplayers.AssetSource('audio/tibetan_chime.wav'));
    startBonusTimer();
    update();
  }

  // The timer that starts as soon as the meditation concludes
  late Timer bonusTimer;
  RxInt bonusTime = 0.obs;

  // Current DateTime
  DateTime lastTimerTime = DateTime.now();

  void startBonusTimer() {
    if (completedInBackgroundBonusTime != 0) {
      bonusTime.value = completedInBackgroundBonusTime;
      completedInBackgroundBonusTime = 0;
    } else {
      bonusTime.value = 0;
    }
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
    // TODO: recreate this with new package
    // FlutterAppBadger.removeBadge();

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

    int timeInMinutesForLevelPoints = timeInMinutes;
    if (timeInMinutesForLevelPoints > 60) {
      timeInMinutesForLevelPoints = 60;
    }

    SaveController saveController = Get.find();
    int xpBoostMultiplier =
        DateTime.now().difference(saveController.xpBoostedAt.value) <
                const Duration(hours: 24)
            ? 2
            : 1;

    bool levelUp = calculateLevel(
            userController.user.value.levelPoints, userController.user.value) <
        calculateLevel(
            userController.user.value.levelPoints +
                timeInMinutesForLevelPoints * xpBoostMultiplier,
            userController.user.value);
    userController.updateProperty(
        UserProperty.levelPoints,
        (userController.user.value.levelPoints +
            timeInMinutesForLevelPoints * xpBoostMultiplier));

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
      int tColor;
      // If the user tier is rainbow, the turtle can be rainbow
      if (userController.streakTier() == Tier.RAINBOW) {
        tColor = Random().nextInt(TURTLE_COLORS.length);
      } else {
        tColor = Random().nextInt(TURTLE_COLORS.length - 1);
      }

      await eggController.addEgg(tColor, tHatch);
    }
    //Log the event to Posthog
    PostHogService posthog = Get.find();
    posthog.logEvent("MEDITATION_COMPLETE", {"time": timeInMinutes.toString()});

    try {
      bonusTimer.cancel();
    } catch (e) {
      logError(e.toString());
    }

    loading.value = false;
    bonusTime.value = 0;
    addExtraTime.value = false;
    update();

    if (save.breathworkSelected.value == true) {
      if (userController.user.value.hasTriedBreathwork == false) {
        userController.updateProperty(UserProperty.hasTriedBreathwork, true);
        save.updateBreathworkSelected(false);
      }
    }

    Get.offAll(StreakCountPage(
      gemsAmount: gemsToGive,
      alreadyMeditatedToday: alreadyMeditatedToday,
      foundEgg: foundEgg,
      levelUp: levelUp,
      turtleToHatch: turtleToHatch,
      turtleColorToHatch: turtleColorToHatch,
    ));
  }
}
