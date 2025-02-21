import 'dart:math';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/pages/trophies/collections.dart';
import 'package:meditate_app/util/logger.dart';
import 'package:meditate_app/util/turtles.dart';

// ignore: constant_identifier_names
const int STREAK_FREEZE_PRICE = 40;

String tierReadable(Tier tier) {
  return tier == Tier.ORANGE
      ? "Beginner Flame"
      : tier == Tier.YELLOW
          ? "Yellow Flame"
          : tier == Tier.BLUE
              ? "Blue Flame"
              : tier == Tier.LITBACK
                  ? "Add Friends to Find"
                  : tier == Tier.AMBIENCE
                      ? "Ambience Turtle"
                      : "Rainbow Flame";
}

String tierReadablePlural(Tier tier) {
  return tier == Tier.ORANGE
      ? "All Users"
      : tier == Tier.YELLOW
          ? "Yellow Flame Users"
          : tier == Tier.BLUE
              ? "Blue Flame Users"
              : tier == Tier.LITBACK
                  ? "Add Friends to Find"
                  : tier == Tier.AMBIENCE
                      ? "Ambience Turtle"
                      : "Rainbow Flame Users";
}

Color tierColor(Tier tier) {
  return tier == Tier.ORANGE
      ? Colors.green
      : tier == Tier.YELLOW
          ? Colors.yellow
          : tier == Tier.BLUE
              ? Colors.lightBlueAccent
              : tier == Tier.LITBACK
                  ? Colors.deepPurpleAccent
                  : tier == Tier.AMBIENCE
                      ? Colors.tealAccent
                      : Colors.redAccent;
}

String rarityReadable(Rarity rarity) {
  return rarity == Rarity.COMMON
      ? "Common"
      : rarity == Rarity.UNCOMMON
          ? "Uncommon"
          : rarity == Rarity.RARE
              ? "Rare"
              : rarity == Rarity.ULTRARARE
                  ? "Ultra Rare"
                  : "Legendary";
}

Color rarityColor(Rarity rarity) {
  return rarity == Rarity.COMMON
      ? Colors.grey
      : rarity == Rarity.UNCOMMON
          ? Colors.green
          : rarity == Rarity.RARE
              ? Colors.blue
              : rarity == Rarity.ULTRARARE
                  ? Colors.orange
                  : Colors.purpleAccent;
}

final Map<int, String> months = {
  1: "January",
  2: "February",
  3: "March",
  4: "April",
  5: "May",
  6: "June",
  7: "July",
  8: "August",
  9: "September",
  10: "October",
  11: "November",
  12: "December"
};

String formatDay(DateTime date) {
  DateTime now = DateTime.now().toLocal();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  final aDate = DateTime(date.year, date.month, date.day);

  if (aDate == today) {
    return "Today";
  } else if (aDate == tomorrow) {
    return "Tomorrow";
  } else if (now.difference(date).inDays <= 6 &&
      now.difference(date).inDays > 0 &&
      now.isBefore(date)) {
    return DateFormat('EEEE').format(date);
  } else {
    return months[date.month]! +
        " " +
        date.day.toString() +
        ", " +
        date.year.toString();
  }
}

String formatMonth(DateTime date) {
  DateTime now = DateTime.now().toLocal();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  date = date.toLocal();
  final aDate = DateTime(date.year, date.month, date.day);

  if (aDate == today) {
    return "today";
  } else if (aDate == tomorrow) {
    return "today";
  } else if (now.difference(date).inDays <= 6 &&
      now.difference(date).inDays > 0 &&
      now.isBefore(date)) {
    return DateFormat('EEEE').format(date);
  } else {
    return months[date.month]! + " " + date.year.toString();
  }
}

double userStreakAverage(User user) {
  DateTime now = DateTime.now();

  // Filter and sort the last seven days
  var lastSevenDays = user.meditationHistory.entries
      .where(
          (entry) => entry.key.isAfter(now.subtract(const Duration(days: 7))))
      .toList();

  // Sort in descending order
  lastSevenDays.sort((a, b) => b.key.compareTo(a.key));

  // Calculate the sum
  double sum = lastSevenDays.fold(0, (prev, entry) => prev + entry.value);

  // Calculate the average
  return lastSevenDays.isNotEmpty ? sum / 7 : 0.0;
}

String userStreakIconURL(User user) {
  return getUserStreak(user) != 0
      ? userStreakTier(user) == Tier.ORANGE
          ? "assets/streak_icon.png"
          : userStreakTier(user) == Tier.YELLOW
              ? "assets/streak_icon_yellow.png"
              : userStreakTier(user) == Tier.BLUE
                  ? "assets/streak_icon_blue.png"
                  : "assets/streak_icon_rainbow.png"
      : "assets/streak_icon_grey.png";
}

Tier userStreakTier(User user) {
  return userStreakAverage(user) < 10
      ? Tier.ORANGE
      : userStreakAverage(user) < 20
          ? Tier.YELLOW
          : userStreakAverage(user) < 40
              ? Tier.BLUE
              : Tier.RAINBOW;
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

int getUserStreak(User user) {
  DateTime now = DateTime.now();
  // TODAY in the local time zone (now moved to utc (as of nov 17 - jacob))
  DateTime today = DateTime.utc(now.year, now.month, now.day);
  DateTime lastMeditatedAdjusted = DateTime.utc(user.lastMeditated.year,
      user.lastMeditated.month, user.lastMeditated.day);
  logInfo("today: ${user.username} $today");
  logInfo("lastMeditatedAdjusted: ${user.username} $lastMeditatedAdjusted");
  if (user.streakFreezes == 0) {
    if (lastMeditatedAdjusted
            .isAfter(today.subtract(const Duration(days: 1))) ||
        lastMeditatedAdjusted
            .isAtSameMomentAs(today.subtract(const Duration(days: 1)))) {
      return user.streak;
    }
  } else if (user.streakFreezes == 1) {
    if (lastMeditatedAdjusted
            .isAfter(today.subtract(const Duration(days: 2))) ||
        lastMeditatedAdjusted
            .isAtSameMomentAs(today.subtract(const Duration(days: 2)))) {
      return user.streak;
    }
  } else if (user.streakFreezes == 2) {
    if (lastMeditatedAdjusted
            .isAfter(today.subtract(const Duration(days: 3))) ||
        lastMeditatedAdjusted
            .isAtSameMomentAs(today.subtract(const Duration(days: 3)))) {
      return user.streak;
    }
  } else if (user.streakFreezes == 3) {
    if (lastMeditatedAdjusted
            .isAfter(today.subtract(const Duration(days: 4))) ||
        lastMeditatedAdjusted
            .isAtSameMomentAs(today.subtract(const Duration(days: 4)))) {
      return user.streak;
    }
  }
  return 0;
}

int calculateTopPercentile(List<int> meditationTimes, int totalMinutes) {
  // Remove all 0 values
  meditationTimes.removeWhere((element) => element <= 2);

  // Sort the meditation times in descending order
  meditationTimes.sort((a, b) => b.compareTo(a));

  // Count how many users have meditation times greater than or equal to totalMinutes
  int rank = meditationTimes.where((time) => time > totalMinutes).length + 1;

  // Calculate percentile
  double percentile = (rank / meditationTimes.length) * 100;

  return percentile.toInt() + 1; // Convert to integer for whole number
}

int calculateLevel(int levelPoints, User user) {
  levelPoints += calculateUserTotalXPFromCollections(user);
  // Define an array for the first 10 levels with their specific point requirements
  List<int> initialThresholds = [
    20,
    50,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100
  ];

  int cumulativePoints = 0;
  int level = 0;

  // Calculate the level within the first 10 levels
  for (int i = 0; i < initialThresholds.length; i++) {
    cumulativePoints += initialThresholds[i];
    if (levelPoints < cumulativePoints) {
      return level + 1; // Return the level starting from 1
    }
    level++;
  }

  // Calculate levels beyond level 10
  int levelIncrement =
      100; // Starting increment for points required beyond level 10
  int levelsPerIncrement =
      10; // Every 10 levels, the points required increases by 100

  while (levelPoints >= cumulativePoints) {
    int pointsForNextLevel =
        levelIncrement * ((level - 10) ~/ levelsPerIncrement + 1);
    cumulativePoints += pointsForNextLevel;
    level++;

    if (levelPoints < cumulativePoints) {
      return level;
    }
  }

  return level;
}

int getRemainingLevelPoints(int levelPoints) {
  levelPoints += calculateTotalXPFromCollections();

  // Define an array for the first 10 levels with their specific point requirements
  List<int> initialThresholds = [
    20,
    50,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100
  ];

  int cumulativePoints = 0;
  int level = 0;

  // Check within the first 10 levels
  for (int i = 0; i < initialThresholds.length; i++) {
    cumulativePoints += initialThresholds[i];
    if (levelPoints < cumulativePoints) {
      return cumulativePoints - levelPoints; // Return remaining points needed
    }
    level++;
  }

  // Calculate for levels beyond level 10
  int levelIncrement = 100;
  int levelsPerIncrement = 10;

  while (true) {
    int pointsForNextLevel =
        levelIncrement * ((level - 10) ~/ levelsPerIncrement + 1);
    cumulativePoints += pointsForNextLevel;

    if (levelPoints < cumulativePoints) {
      return cumulativePoints - levelPoints;
    }
    level++;
  }
}

double calculateRemainingLevelPercentage(int levelPoints) {
  levelPoints += calculateTotalXPFromCollections();
  // Define an array for the first 10 levels with their specific point requirements
  List<int> initialThresholds = [
    20,
    50,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100
  ];

  int cumulativePoints = 0;
  int level = 0;

  // Calculate the level within the first 10 levels
  for (int i = 0; i < initialThresholds.length; i++) {
    cumulativePoints += initialThresholds[i];
    if (levelPoints < cumulativePoints) {
      int pointsForCurrentLevel = initialThresholds[i];
      int pointsInCurrentLevel =
          levelPoints - (cumulativePoints - pointsForCurrentLevel);
      return pointsInCurrentLevel / pointsForCurrentLevel;
    }
    level++;
  }

  // Calculate levels beyond level 10
  int levelIncrement =
      100; // Starting increment for points required beyond level 10
  int levelsPerIncrement =
      10; // Every 10 levels, the points required increases by 100

  while (levelPoints >= cumulativePoints) {
    int pointsForNextLevel =
        levelIncrement * ((level - 10) ~/ levelsPerIncrement + 1);
    cumulativePoints += pointsForNextLevel;
    level++;

    if (levelPoints < cumulativePoints) {
      int pointsInCurrentLevel =
          levelPoints - (cumulativePoints - pointsForNextLevel);
      return pointsInCurrentLevel / pointsForNextLevel;
    }
  }

  return 1.0; // Fully completed level percentage
}

//For the streak chart
// get the highest value of the week. first slice the map to the last 7 days
int getMaxValueForStreakChart(Map<DateTime, int> map) {
  int highest = 0;
  map.forEach((key, value) {
    if (key.isAfter(DateTime.now().subtract(const Duration(days: 7)))) {
      if (value > highest) {
        highest = value;
      }
    }
  });

  // Adjust highest value based on the requirements
  highest += 15;

  //  round highest to the nearest 10
  highest = (highest / 10).ceil() * 10;
  return highest;
}

int calculateOnboardingPercentage(bool meditated, bool profilePictureAdded,
    bool streakFreezeGot, bool addedFriend, bool breathworkTried) {
  int percentage = 17;

  // plus create an account which is already true
  if (meditated) {
    percentage += 16;
  }
  if (profilePictureAdded) {
    percentage += 16;
  }
  if (streakFreezeGot) {
    percentage += 16;
  }
  if (addedFriend) {
    percentage += 16;
  }
  if (breathworkTried) {
    percentage += 16;
  }

  return percentage;
}

// availableTurtles function - given a date (not time) as the seed, returns 10 unique turtle colors and types
List<List<int>> availableTurtles(DateTime date) {
  List<List<int>> availableTurtles = [];
  List<int> availableColors =
      List.generate(TURTLE_COLORS.length, (index) => index);
  List<int> availableTypes = List.generate(TURTLES.length, (index) => index);

  // remove all turtles that require an ambience to meditate or are litback
  availableTypes.removeWhere((element) =>
      TURTLES[element].foundIn != null ||
      TURTLES[element].tier == Tier.LITBACK);

  // Shuffle the available colors and types
  availableColors.shuffle(Random(date.millisecondsSinceEpoch));
  availableTypes.shuffle(Random(date.millisecondsSinceEpoch));

  // Select the first 10 unique turtle colors and types
  for (int i = 0; i < 10; i++) {
    availableTurtles.add([availableTypes[i], availableColors[i]]);
  }

  return availableTurtles;
}

int calculateTurtlePrice(int id, int color) {
  int rainbowBoost = 1;
  if (color == 18) {
    rainbowBoost = 2;
  }

  return (TURTLES[id].rarity.index * 100 + 35 + color * 3) * rainbowBoost +
      TURTLES[id].level * 4;
}

bool hasTurtle(
  int id,
  int color,
) {
  UserController user = Get.find();

  if (id == 0 && color == 0) {
    return true;
  }
  return user.user.value.unlockedTurtleColors[id].contains(color);
}

bool get isCanada {
  final locale = Platform.localeName;
  return locale.contains('CA') || locale.contains('ca');
}

String userAdditionalEmoji(User user) {
  DateTime lastMeditated = DateTime.utc(user.lastMeditated.year,
      user.lastMeditated.month, user.lastMeditated.day);

  // if the user hasn't meditated today, and it's 11pm, show a timer emoji
  if (lastMeditated.isBefore(DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day)) &&
      !DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).isBefore(lastMeditated) &&
      DateTime.now().hour >= 20) {
    return "⏳";
  }

  if (user.totalMinutes <= 10) {
    return "👶";
  }

  if (user.streak % 10 == 0 && user.streak >= 10) {
    return "🎉";
  }

  return "";
}

Offset unrotateOffset(Offset offset, double angle) {
  double cosTheta = cos(angle);
  double sinTheta = sin(angle);

  double unrotatedX = offset.dx * cosTheta + offset.dy * sinTheta;
  double unrotatedY = -offset.dx * sinTheta + offset.dy * cosTheta;

  return Offset(unrotatedX, unrotatedY);
}

bool isTurtleSoldOut(List<List<int>> turtleOptions, int i) {
  if (i >= turtleOptions.length) {
    return true;
  }

  // for x turtle options, at 24-x hours, remove the x-th turtle option sorted in order of turtleprice
  // if the turtle is sold out, return true
  List<List<int>> sortedTurtles = List.from(turtleOptions);
  // sort the turtle options by price
  sortedTurtles.sort((a, b) => calculateTurtlePrice(a[0], a[1])
      .compareTo(calculateTurtlePrice(b[0], b[1])));

  // remove however many turtles as there are hours until midnight
  int hoursUntilMidnight = DateTime.now().hour - 14;

  if (hoursUntilMidnight < 0) {
    return false;
  }

  if (hoursUntilMidnight > sortedTurtles.length) {
    return true;
  }

  for (int i = 0; i < hoursUntilMidnight; i++) {
    // remove the most expensive turtle
    sortedTurtles.removeLast();
  }

  // if the turtle is sold out, return true
  return !sortedTurtles.contains(turtleOptions[i]);
}

int calculateTotalXPFromCollections() {
  int totalXP = 0;

  for (final collection in COLLECTIONS) {
    bool allTurtlesUnlocked = collection.turtles.every(
      (turtle) => hasTurtle(turtle[0], turtle[1]),
    );

    if (allTurtlesUnlocked) {
      totalXP += collection.xp;
    }
  }

  return totalXP;
}

int calculateUserTotalXPFromCollections(User user) {
  int totalXP = 0;

  for (final collection in COLLECTIONS) {
    bool allTurtlesUnlocked = collection.turtles.every(
      (turtle) => userHasTurtle(turtle[0], turtle[1], user),
    );

    if (allTurtlesUnlocked) {
      totalXP += collection.xp;
    }
  }

  return totalXP;
}

bool userHasTurtle(
  int id,
  int color,
  User user,
) {
  if (id == 0 && color == 0) {
    return true;
  }
  return user.unlockedTurtleColors[id].contains(color);
}

// ignore: non_constant_identifier_names
DateTime PREMIUM_BEFORE_DATE = DateTime(2025, 2, 22, 0, 0);
