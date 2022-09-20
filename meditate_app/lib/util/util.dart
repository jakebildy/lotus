import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/util/turtles.dart';

String tier() {
  SaveController saveController = Get.find();

  return saveController.streakTier() == Tier.ORANGE
      ? "Hatchling (Level 1)"
      : saveController.streakTier() == Tier.YELLOW
          ? "Champion (Level 2)"
          : saveController.streakTier() == Tier.BLUE
              ? "Expert (Level 3)"
              : "Turtlemaster (Level 4)";
}

Color tierColor() {
  SaveController saveController = Get.find();

  return saveController.streakTier() == Tier.ORANGE
      ? Colors.orange
      : saveController.streakTier() == Tier.YELLOW
          ? Colors.yellow
          : saveController.streakTier() == Tier.BLUE
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
