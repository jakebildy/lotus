import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/util/turtles.dart';

String tierReadable(Tier tier) {
  return tier == Tier.ORANGE
      ? "Orange Flame"
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
      ? "Orange Flame Users"
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
      ? Colors.orange
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
  DateTime date = DateTime(now.year, now.month, now.day);
  int daysShifted = user.meditationTimesAsOf.difference(date).inDays.abs();
  List<double> lastSevenDays = [
    daysShifted >= 1 ? 0.0 : user.meditationTimes[0 - daysShifted].toDouble(),
    daysShifted >= 2 ? 0.0 : user.meditationTimes[1 - daysShifted].toDouble(),
    daysShifted >= 3 ? 0.0 : user.meditationTimes[2 - daysShifted].toDouble(),
    daysShifted >= 4 ? 0.0 : user.meditationTimes[3 - daysShifted].toDouble(),
    daysShifted >= 5 ? 0.0 : user.meditationTimes[4 - daysShifted].toDouble(),
    daysShifted >= 6 ? 0.0 : user.meditationTimes[5 - daysShifted].toDouble(),
    daysShifted >= 7 ? 0.0 : user.meditationTimes[6 - daysShifted].toDouble(),
  ];

  double sum = 0;
  for (double i in lastSevenDays) {
    sum += i;
  }
  return sum / 7;
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
  // TODAY in the local time zone
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime lastMeditatedAdjusted = DateTime(user.lastMeditated.year,
      user.lastMeditated.month, user.lastMeditated.day);
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
  }
  return 0;
}

int calculateTopPercentile(List<int> meditationTimes, int totalMinutes) {
  // Remove all 0 values
  meditationTimes.removeWhere((element) => element == 0);

  // Sort the meditation times in descending order
  meditationTimes.sort((a, b) => b.compareTo(a));

  // Count how many users have meditation times greater than or equal to totalMinutes
  int rank = meditationTimes.where((time) => time > totalMinutes).length + 1;

  // Calculate percentile
  double percentile = (rank / meditationTimes.length) * 100;

  return percentile.toInt(); // Convert to integer for whole number
}
