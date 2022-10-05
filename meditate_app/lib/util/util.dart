import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/models/user.dart';
import 'package:meditate_app/util/turtles.dart';

String tierReadable(Tier tier) {
  return tier == Tier.ORANGE
      ? "Hatchling (Level 1)"
      : tier == Tier.YELLOW
          ? "Champion (Level 2)"
          : tier == Tier.BLUE
              ? "Expert (Level 3)"
              : "Turtlemaster (Level 4)";
}

String tierReadablePlural(Tier tier) {
  return tier == Tier.ORANGE
      ? "Hatchlings\n(Level 1)"
      : tier == Tier.YELLOW
          ? "Champions\n(Level 2)"
          : tier == Tier.BLUE
              ? "Experts\n(Level 3)"
              : "Turtlemasters\n(Level 4)";
}

Color tierColor(Tier tier) {
  return tier == Tier.ORANGE
      ? Colors.green
      : tier == Tier.YELLOW
          ? Colors.yellow
          : tier == Tier.BLUE
              ? Colors.lightBlueAccent
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
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day);
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
  bool hasDoneStreakToday = true;
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day);
  int numDays = user.lastMeditated.difference(date).inDays.abs();

  if (numDays >= 1) {
    hasDoneStreakToday = false;
  }

  return user.streak != 0
      ? userStreakAverage(user) < 20
          ? "assets/streak_icon.png"
          : userStreakAverage(user) < 40
              ? "assets/streak_icon_yellow.png"
              : userStreakAverage(user) < 60
                  ? "assets/streak_icon_blue.png"
                  : "assets/streak_icon_rainbow.png"
      : "assets/streak_icon_grey.png";
}

Tier userStreakTier(User user) {
  return userStreakAverage(user) < 20
      ? Tier.ORANGE
      : userStreakAverage(user) < 40
          ? Tier.YELLOW
          : userStreakAverage(user) < 60
              ? Tier.BLUE
              : Tier.RAINBOW;
}
